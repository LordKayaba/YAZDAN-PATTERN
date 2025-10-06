Shader "Yazdan/Glow"
{
    Properties
    {
        _BaseColor("Base Color", Color) = (1,1,1,1)
        _GlowIntensity("Glow Intensity", Float) = 1.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }
        LOD 100

        Pass
        {
            Tags { "LightMode"="UniversalForward" }
            
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float3 positionOS : POSITION;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 localPos : TEXCOORD0;
            };

            UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_DEFINE_INSTANCED_PROP(float4, _BaseColor)
            UNITY_DEFINE_INSTANCED_PROP(float, _GlowIntensity)
            UNITY_INSTANCING_BUFFER_END(Props)

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionCS = TransformObjectToHClip(IN.positionOS);
                OUT.localPos = IN.positionOS;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                float4 baseColor = UNITY_ACCESS_INSTANCED_PROP(Props, _BaseColor);
                float glowIntensity = UNITY_ACCESS_INSTANCED_PROP(Props, _GlowIntensity);

                float dist = length(IN.localPos);
                float glow = exp(-dist * glowIntensity);

                return baseColor * glow;
            }
            ENDHLSL
        }
    }
    FallBack "Unlit/Color"
}