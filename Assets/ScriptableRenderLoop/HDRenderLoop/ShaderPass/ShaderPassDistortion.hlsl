#if SHADERPASS != SHADERPASS_DISTORTION
#error SHADERPASS_is_not_correctly_define
#endif

float4 Frag(PackedVaryings packedInput) : SV_Target
{
    FragInputs input = UnpackVaryings(packedInput);

    // input.unPositionSS is SV_Position
    PositionInputs posInput = GetPositionInput(input.unPositionSS.xy, _ScreenSize.zw);
    UpdatePositionInput(input.unPositionSS.z, input.unPositionSS.w, input.positionWS, posInput);
    float3 V = GetWorldSpaceNormalizeViewDir(input.positionWS);

    // Perform alpha testing + get distortion
    SurfaceData surfaceData;
    BuiltinData builtinData;
    GetSurfaceAndBuiltinData(input, V, posInput, surfaceData, builtinData);

    float4 outBuffer;
    EncodeDistortion(builtinData.distortion, builtinData.distortionBlur, outBuffer);
    return outBuffer;
}
