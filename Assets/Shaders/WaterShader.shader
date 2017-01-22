Shader "TFTM/Distortion/Water" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,0.5)
    
		_SpeedX ("SpeedX",Float)=1.0
		_SpeedY ("SpeedY",Float)=1.0
		_Intensity ("Stiffness",Float)=16.0
		_MainTex ("Texture", 2D) = "white" { }    
		_NoiseATex ("NoiseA", 2D) = "white" { }
		_NoiseBTex ("NoiseB", 2D) = "white" { }
   
	}
	SubShader {
		Tags {"Queue" = "Transparent" }
		Pass {
		Blend SrcAlpha OneMinusSrcAlpha     
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag	
		#include "UnityCG.cginc"	
		#pragma target 2.0
		float4 _Color;
		sampler2D _MainTex,_MaskTex,_NoiseATex,_NoiseBTex;
	
		struct v2f {
			float4  pos : SV_POSITION;
			float2  uv : TEXCOORD0;
		};	
		float4 _MainTex_ST;	
		float _SliderValue,_SpeedX,_SpeedY,_Intensity;
		v2f vert (appdata_base v){
			v2f o;
			o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
			o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
	  		//o.uv.x+=_SpeedX*_Time.x;
	   		//o.uv.y+=_SpeedY*_Time.x;
	    
			return o;
		}	
		half4 frag (v2f i) : COLOR{	
		
		
			half4 noiseAcol=tex2D (_NoiseATex, i.uv);
			half4 noiseBcol=tex2D (_NoiseBTex, i.uv);
		
		
			half2 movedUV=i.uv;	
			half2 time;
			time.x=_Time.y*_SpeedX;
			time.y=_Time.y*_SpeedY;
			movedUV.x+=(noiseAcol.r)*(sin((time.x)+4.0)/_Intensity);
			movedUV.y+=(noiseAcol.r)*(sin((time.y)+4.0)/_Intensity);
			movedUV.x+=(noiseBcol.r)*(cos((time.x)+6.0)/_Intensity);
			movedUV.y+=(noiseBcol.r)*(cos((time.y)+6.0)/_Intensity);	   
			half4 texcol=tex2D (_MainTex, movedUV);
			texcol=texcol*_Color;	
	
			return texcol;
		}
		ENDCG

		}
	}
	Fallback "VertexLit"
} 