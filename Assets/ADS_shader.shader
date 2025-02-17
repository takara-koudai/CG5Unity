Shader "Unlit/ADS_shader"
{
    //色追加(コメントアウト解除で自由に色を決められる)
	Properties
	{
		_Color("Color",Color) = (1,0,0,1)
	}

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            fixed4 _Color;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            float4 vert(float4 v:POSITION) : SV_POSITION
			{
				float4 o;
				o = UnityObjectToClipPos(v);
				return o;
			}

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 worldPosition : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPosition = mul(unity_ObjectToWorld,v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //暗めの_Colorに光源の色をかけた色
                fixed4 ambient = _Color * 0.3 * _LightColor0;

                //diffuseｍｐ計算結果と_Color、光源の色の掛け算
                float intensity = saturate(dot(normalize(i.normal),_WorldSpaceLightPos0));
                fixed4 color = fixed4(1,1,1,1);

                fixed4 diffuse = color * intensity * _LightColor0;

                //specularの計算結果と光源の色の掛け算
                float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
                float3 lightDir = normalize(_WorldSpaceLightPos0);
                i.normal = normalize(i.normal);
                float3 reflectDir = -lightDir + 2 * i.normal * dot(i.normal,lightDir);

                fixed4 specular = pow(saturate(dot(reflectDir,eyeDir)),20) * _LightColor0;

                fixed4 phong = ambient + diffuse + specular;
                return phong;
            }
            ENDCG
        }
    }
}
