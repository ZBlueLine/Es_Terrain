using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Windows;

namespace Utility
{
    public class Es_TerrainAlbemMaker
    {
        static int adgeAdd;
        static public void MakeAlbedoAtlas(Material myMaterial)
        {
            Texture2D[] TextureList = new Texture2D[16];
            int sqrCount = 4;
            char id = '0';
            Color[] Colors = new Color[256*256];
            int len = Colors.Length;
            for(int i = 0; i < len; ++i)
                Colors[i] = new Color(0, 0, 0, 0);
            for(int i = 0; i < 16; ++i)
            {
                if (myMaterial.HasProperty("_Splat" + id))
                {
                    Debug.Log("_Splat" + id);
                    TextureList[i] = (Texture2D)myMaterial.GetTexture("_Splat" + id);
                }
                else
                {
                    Debug.Log(i);
		            TextureList[i] = new Texture2D (256, 256,  TextureFormat.ARGB32, true);
                    TextureList[i].SetPixels(Colors);
                }
                ++id;
            }
            int wid = TextureList[0].width;
            int hei =TextureList[0].height;
            adgeAdd = 1;

            Texture2D albedoAtlas = new Texture2D(sqrCount * wid +  adgeAdd*sqrCount*2, sqrCount * hei + adgeAdd * sqrCount * 2, TextureFormat.RGBA32, true);
            Texture2D normalAtlas = new Texture2D(sqrCount * wid + adgeAdd * sqrCount * 2, sqrCount * hei + adgeAdd * sqrCount * 2, TextureFormat.RGBA32, true);
            Debug.Log(albedoAtlas.width);
            for (int i = 0; i < sqrCount; i++)
            {
                for (int j = 0; j < sqrCount; j++)
                {
                    int index = i * sqrCount + j;

                    if (index >= TextureList.Length) break;
                    copyToAltas(TextureList[index], albedoAtlas, i, j, wid, hei);
                    //copyToAltas(normalTerrainData.splatPrototypes[index].normalMap, normalAtlas, i, j, wid, hei);
                }
            }

            albedoAtlas.Apply();
            normalAtlas.Apply();
            File.WriteAllBytes(Application.dataPath+"/albedoAtlas.png",albedoAtlas.EncodeToPNG());
            File.WriteAllBytes(Application.dataPath+"/normalAtlas.png",normalAtlas.EncodeToPNG());
            Object.DestroyImmediate(albedoAtlas);
            Object.DestroyImmediate(normalAtlas);
        }
        static private void copyToAltas(Texture2D src, Texture2D texture, int i, int j, int wid, int hei)
        {
        
            if (src == null) return;
            //原始像素
            texture.SetPixels(j * (wid + 2 * adgeAdd) + adgeAdd, i * (hei + 2 * adgeAdd) + adgeAdd, wid, hei, src.GetPixels());
        
            //加4条边

            var lineColors = src.GetPixels(wid - 1, 0, 1, hei);
            var fillColor = new Color[hei * adgeAdd];
            for (int k = 0; k < hei * adgeAdd; k++)
            {
                fillColor[k] = lineColors[k % hei];
            }
            texture.SetPixels(j * (wid + 2 * adgeAdd), i * (hei + 2 * adgeAdd) + adgeAdd, adgeAdd, hei, fillColor);

            lineColors = src.GetPixels(0, 0, 1, hei);
            for (int k = 0; k < hei * adgeAdd; k++)
            {
                fillColor[k] = lineColors[k % hei];
            }
            texture.SetPixels(j * (wid + 2 * adgeAdd) + wid + adgeAdd, i * (hei + 2 * adgeAdd) + adgeAdd, adgeAdd, hei, fillColor);

            fillColor = new Color[wid * adgeAdd];
            lineColors = src.GetPixels(0, hei - 1, wid, 1);
            for (int k = 0; k < wid * adgeAdd; k++)
            {
                fillColor[k] = lineColors[k % wid];
            }

            texture.SetPixels(j * (wid + 2 * adgeAdd) + adgeAdd, i * (hei + 2 * adgeAdd), wid, adgeAdd, fillColor);
            lineColors = src.GetPixels(0, 0, wid, 1);
            for (int k = 0; k < wid * adgeAdd; k++)
            {
                fillColor[k] = lineColors[k % wid];
            }

            texture.SetPixels(j * (wid + 2 * adgeAdd) + adgeAdd, i * (hei + 2 * adgeAdd) + hei + adgeAdd, wid, adgeAdd, fillColor);


            //加4个角
            var cornerColor = src.GetPixel(0, hei - 1);
            fillColor = new Color[adgeAdd * adgeAdd];
            for (int k = 0; k < fillColor.Length; k++)
            {
                fillColor[k] = cornerColor;
            }
            texture.SetPixels(j * (wid + 2 * adgeAdd), i * (hei + 2 * adgeAdd), adgeAdd, adgeAdd, fillColor);
            cornerColor = src.GetPixel(0, 0);

            for (int k = 0; k < fillColor.Length; k++)
            {
                fillColor[k] = cornerColor;
            }
            texture.SetPixels(j * (wid + 2 * adgeAdd), i * (hei + 2 * adgeAdd) + hei + adgeAdd, adgeAdd, adgeAdd, fillColor);

            cornerColor = src.GetPixel(wid - 1, hei - 1);

            for (int k = 0; k < fillColor.Length; k++)
            {
                fillColor[k] = cornerColor;
            }
            texture.SetPixels(j * (wid + 2 * adgeAdd) + adgeAdd + wid, i * (hei + 2 * adgeAdd), adgeAdd, adgeAdd, fillColor);


            cornerColor = src.GetPixel(wid - 1, 0);

            for (int k = 0; k < fillColor.Length; k++)
            {
                fillColor[k] = cornerColor;
            }
            texture.SetPixels(j * (wid + 2 * adgeAdd) + adgeAdd + wid, i * (hei + 2 * adgeAdd) + hei + adgeAdd, adgeAdd, adgeAdd, fillColor);

        }
    }
}
