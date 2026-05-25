<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="3.36.0" styleCategories="AllStyleCategories">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
    <Private>0</Private>
  </flags>
  <renderer-v2 type="categorizedSymbol" attr="platform_door" forceraster="0" symbollevels="0" enableorderby="0" referencescale="-1">
    <categories>
      <category render="true" value="0" label="ホームドアなし" symbol="0" uuid="{00000000-0000-0000-0000-000000000000}"/>
      <category render="true" value="1" label="ホームドアあり" symbol="1" uuid="{11111111-1111-1111-1111-111111111111}"/>
    </categories>
    <symbols>
      <!-- ホームドアなし: 赤系 -->
      <symbol name="0" type="marker" force_rhr="0" clip_to_extent="1" alpha="0.85">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" class="SimpleMarker" enabled="1" locked="0">
          <Option type="Map">
            <Option name="angle" value="0" type="QString"/>
            <Option name="cap_style" value="square" type="QString"/>
            <Option name="color" value="220,80,80,200" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="name" value="circle" type="QString"/>
            <Option name="offset" value="0,0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="outline_color" value="180,60,60,200" type="QString"/>
            <Option name="outline_style" value="solid" type="QString"/>
            <Option name="outline_width" value="0.2" type="QString"/>
            <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="outline_width_unit" value="MM" type="QString"/>
            <Option name="scale_method" value="diameter" type="QString"/>
            <Option name="size" value="3" type="QString"/>
            <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="size_unit" value="MM" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" value="true" type="bool"/>
                  <Option name="expression" value="scale_linear(sqrt(coalesce(&quot;S12_061&quot;,0)),0,1330,1,15)" type="QString"/>
                  <Option name="type" value="3" type="int"/>
                </Option>
              </Option>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <!-- ホームドアあり: 青系 -->
      <symbol name="1" type="marker" force_rhr="0" clip_to_extent="1" alpha="0.85">
        <data_defined_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" class="SimpleMarker" enabled="1" locked="0">
          <Option type="Map">
            <Option name="angle" value="0" type="QString"/>
            <Option name="cap_style" value="square" type="QString"/>
            <Option name="color" value="60,120,220,200" type="QString"/>
            <Option name="joinstyle" value="bevel" type="QString"/>
            <Option name="name" value="circle" type="QString"/>
            <Option name="offset" value="0,0" type="QString"/>
            <Option name="offset_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="offset_unit" value="MM" type="QString"/>
            <Option name="outline_color" value="40,90,180,200" type="QString"/>
            <Option name="outline_style" value="solid" type="QString"/>
            <Option name="outline_width" value="0.2" type="QString"/>
            <Option name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="outline_width_unit" value="MM" type="QString"/>
            <Option name="scale_method" value="diameter" type="QString"/>
            <Option name="size" value="3" type="QString"/>
            <Option name="size_map_unit_scale" value="3x:0,0,0,0,0,0" type="QString"/>
            <Option name="size_unit" value="MM" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" value="true" type="bool"/>
                  <Option name="expression" value="scale_linear(sqrt(coalesce(&quot;S12_061&quot;,0)),0,1330,1,15)" type="QString"/>
                  <Option name="type" value="3" type="int"/>
                </Option>
              </Option>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
    <orderby/>
  </renderer-v2>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style fontFamily="Noto Sans CJK JP" fontItalic="0" fontBold="0" fontSize="8"
                  fontSizeUnit="Point" textColor="50,50,50,255" textOpacity="1"
                  fieldName="&quot;S12_001&quot; || '\n' || format_number(&quot;S12_061&quot;, 0) || '人'" isExpression="1"
                  namedStyle="Regular" capitalization="0" allowHtml="0"
                  fontLetterSpacing="0" fontWordSpacing="0" fontStrikeout="0"
                  fontUnderline="0" multilineHeight="1" blendMode="0"
                  fontSizeMapUnitScale="3x:0,0,0,0,0,0" previewBkgrdColor="255,255,255,255"
                  useSubstitutions="0" forcedBold="0" forcedItalic="0"
                  legendString="Aa" multilineHeightUnit="Proportional">
        <text-buffer bufferEnabled="1" bufferSize="1" bufferSizeUnits="MM"
                     bufferColor="255,255,255,230" bufferOpacity="1"
                     bufferBlendMode="0" bufferJoinStyle="128"
                     bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferDraw="1"
                     bufferNoFill="1"/>
        <text-mask maskEnabled="0" maskSize="0" maskSizeUnits="MM" maskOpacity="1"
                   maskType="0" maskJoinStyle="128" maskedSymbolLayers=""
                   maskSizeMapUnitScale="3x:0,0,0,0,0,0"/>
        <background shapeDraw="0" shapeType="0" shapeSizeType="0" shapeSizeX="0"
                    shapeSizeY="0" shapeSizeUnits="MM" shapeRotationType="0"
                    shapeRotation="0" shapeOffsetX="0" shapeOffsetY="0"
                    shapeOffsetUnits="MM" shapeRadiiX="0" shapeRadiiY="0"
                    shapeRadiiUnits="MM" shapeFillColor="255,255,255,255"
                    shapeBorderColor="128,128,128,255" shapeBorderWidth="0"
                    shapeBorderWidthUnits="MM" shapeJoinStyle="64" shapeOpacity="1"
                    shapeBlendMode="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0"
                    shapeOffsetMapUnitScale="3x:0,0,0,0,0,0"
                    shapeRadiiMapUnitScale="3x:0,0,0,0,0,0"/>
        <shadow shadowDraw="0"/>
        <dd_properties>
          <Option type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
        </dd_properties>
        <substitutions/>
      </text-style>
      <text-format wrapChar="" multilineAlign="3" addDirectionSymbol="0"
                   leftDirectionSymbol="&lt;" rightDirectionSymbol="&gt;"
                   reverseDirectionSymbol="0" placeDirectionSymbol="0"
                   formatNumbers="0" decimals="3" plusSign="0" autoWrapLength="0"
                   useMaxLineLengthForAutoWrap="1"/>
      <placement placement="0" centroidWhole="0" centroidInside="0"
                 overrunDistance="0" overrunDistanceUnit="MM"
                 overrunDistanceMapUnitScale="3x:0,0,0,0,0,0"
                 dist="1" distUnits="MM" distMapUnitScale="3x:0,0,0,0,0,0"
                 offsetType="0" quadOffset="4" xOffset="0" yOffset="0"
                 offsetUnits="MM" angleOffset="0" preserveRotation="1"
                 maxCurvedCharAngleIn="25" maxCurvedCharAngleOut="-25"
                 priority="5" repeatDistance="0" repeatDistanceUnits="MM"
                 repeatDistanceMapUnitScale="3x:0,0,0,0,0,0"
                 placementFlags="10" allowDegraded="0"
                 overlapHandling="PreventOverlap" zIndex="0"
                 lineAnchorType="0" lineAnchorClipping="0"
                 lineAnchorPercent="0.5" lineAnchorTextPoint="FollowPlacement"
                 geometryGenerator="" geometryGeneratorEnabled="0"
                 geometryGeneratorType="PointGeometry"
                 layerType="PointGeometry" fitInPolygonOnly="0"
                 polygonPlacementFlags="2"/>
      <rendering obstacle="1" obstacleFactor="1" obstacleType="1"
                 zIndex="0" scaleVisibility="1" minScale="1" maxScale="100000"
                 limitNumLabels="0" maxNumLabels="2000" minFeatureSize="0"
                 fontLimitPixelSize="0" fontMinPixelSize="3" fontMaxPixelSize="10000"
                 drawLabels="1" upsidedownLabels="0" labelPerPart="0"
                 mergeLines="0" scaleMin="50000" scaleMax="500000"/>
      <dd_properties>
        <Option type="Map">
          <Option name="name" value="" type="QString"/>
          <Option name="properties" type="Map">
            <Option name="show" type="Map">
              <Option name="active" value="true" type="bool"/>
              <Option name="expression" value="&quot;S12_061&quot; >= 100000" type="QString"/>
              <Option name="type" value="3" type="int"/>
            </Option>
          </Option>
          <Option name="type" value="collection" type="QString"/>
        </Option>
      </dd_properties>
      <callout type="simple">
        <Option type="Map">
          <Option name="anchorPoint" value="pole_of_inaccessibility" type="QString"/>
          <Option name="blendMode" value="0" type="int"/>
          <Option name="ddProperties" type="Map">
            <Option name="name" value="" type="QString"/>
            <Option name="properties"/>
            <Option name="type" value="collection" type="QString"/>
          </Option>
          <Option name="drawToAllParts" value="false" type="bool"/>
          <Option name="enabled" value="0" type="QString"/>
          <Option name="labelAnchorPoint" value="point_on_exterior" type="QString"/>
          <Option name="lineSymbol" value="&lt;symbol name=&quot;symbol&quot; type=&quot;line&quot; alpha=&quot;1&quot; clip_to_extent=&quot;1&quot; force_rhr=&quot;0&quot;>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option name=&quot;name&quot; value=&quot;&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option name=&quot;type&quot; value=&quot;collection&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;layer class=&quot;SimpleLine&quot; enabled=&quot;1&quot; pass=&quot;0&quot; locked=&quot;0&quot;>&lt;Option type=&quot;Map&quot;>&lt;Option name=&quot;line_color&quot; value=&quot;60,60,60,255&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;line_width&quot; value=&quot;0.3&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/layer>&lt;/symbol>" type="QString"/>
          <Option name="minLength" value="0" type="double"/>
          <Option name="minLengthMapUnitScale" value="3x:0,0,0,0,0,0" type="QString"/>
          <Option name="minLengthUnit" value="MM" type="QString"/>
          <Option name="offsetFromAnchor" value="0" type="double"/>
          <Option name="offsetFromAnchorMapUnitScale" value="3x:0,0,0,0,0,0" type="QString"/>
          <Option name="offsetFromAnchorUnit" value="MM" type="QString"/>
          <Option name="offsetFromLabel" value="0" type="double"/>
          <Option name="offsetFromLabelMapUnitScale" value="3x:0,0,0,0,0,0" type="QString"/>
          <Option name="offsetFromLabelUnit" value="MM" type="QString"/>
        </Option>
      </callout>
    </settings>
  </labeling>
  <customproperties>
    <Option/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <legend type="default-vector" showLabelLegend="0"/>
  <mapTip enabled="1"></mapTip>
</qgis>
