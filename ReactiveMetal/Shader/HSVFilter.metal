//
//  HSVFilter.metal
//  ReactiveMetal
//
//  Created by s.kananat on 2018/12/14.
//  Copyright © 2018 s.kananat. All rights reserved.
//

#include "MTLHeader.h"

/// Transforms RGB color space to HSV
half3 rgb_to_hsv(half3 c)
{
    half4 K = half4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    half4 p = mix(half4(c.bg, K.wz), half4(c.gb, K.xy), step(c.b, c.g));
    half4 q = mix(half4(p.xyw, c.r), half4(c.r, p.yzx), step(p.x, c.r));
    
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return half3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

/// Transforms HSV color space to RGB
half3 hsv_to_rgb(half3 c)
{
    half4 K = half4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    half3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

/// HSV fragment shader
fragment half4 fragment_hsv(OutputVertex input [[stage_in]], texture2d<half> texture [[texture(0)]], device const float &hue [[buffer(0)]], device const float &saturation [[buffer(1)]], device const float &value [[buffer(2)]]) {
    constexpr sampler defaultSampler;
    half4 color = texture.sample(defaultSampler, input.texcoord);
    
    half3 hsv = rgb_to_hsv(color.rgb);
    hsv.x += hue;
    hsv.yz *= half2(saturation, value);
    half3 rgb = hsv_to_rgb(hsv);
    
    return half4(rgb, color.a);
}

