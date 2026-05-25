"""Range request対応ローカルサーバー（PMTiles用）"""
import http.server
import os

class RangeHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def send_head(self):
        path = self.translate_path(self.path)
        if not os.path.isfile(path):
            return super().send_head()

        try:
            f = open(path, "rb")
        except OSError:
            self.send_error(404)
            return None

        fs = os.fstat(f.fileno())
        file_size = fs.st_size
        ctype = self.guess_type(path)

        range_header = self.headers.get("Range")
        if not range_header:
            self.send_response(200)
            self.send_header("Content-type", ctype)
            self.send_header("Content-Length", str(file_size))
            self.send_header("Accept-Ranges", "bytes")
            self.send_header("Last-Modified", self.date_time_string(fs.st_mtime))
            self.end_headers()
            return f

        # Range リクエスト処理
        try:
            unit, ranges = range_header.split("=", 1)
            assert unit.strip() == "bytes"
            start_str, end_str = ranges.strip().split("-", 1)
            start = int(start_str) if start_str else 0
            end   = int(end_str)   if end_str   else file_size - 1
            end   = min(end, file_size - 1)
            length = end - start + 1
        except Exception:
            self.send_error(416, "Range Not Satisfiable")
            f.close()
            return None

        f.seek(start)
        self.send_response(206)
        self.send_header("Content-type", ctype)
        self.send_header("Content-Range", f"bytes {start}-{end}/{file_size}")
        self.send_header("Content-Length", str(length))
        self.send_header("Accept-Ranges", "bytes")
        self.end_headers()

        # ファイルオブジェクトをそのまま返せないので直接送信
        remaining = length
        while remaining > 0:
            chunk = f.read(min(65536, remaining))
            if not chunk:
                break
            self.wfile.write(chunk)
            remaining -= len(chunk)
        f.close()
        return None

    def log_message(self, fmt, *args):
        print(fmt % args)

if __name__ == "__main__":
    import sys
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    with http.server.HTTPServer(("", port), RangeHTTPRequestHandler) as httpd:
        print(f"Serving at http://localhost:{port}")
        httpd.serve_forever()
