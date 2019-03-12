function handles = initLambdas_v2(handles)

handles.lambda.U238 = 1.55125e-10;
handles.lambda.U235 = 9.8485e-10;
handles.lambda.U234 = 2.82206e-6;
handles.lambda.Th230 = 9.1705e-6;
handles.lambda.Ra226 = log(2)/1599;
handles.lambda.Pa231 = log(2)/32760;

handles.lambda.U238oneSigmaAbs = 8.299963125e-14;
handles.lambda.U235oneSigmaAbs = 6.700033035e-13;
handles.lambda.U234oneSigmaAbs = 8.054670e-17;
handles.lambda.Th230oneSigmaAbs = 1.395999788e-8;
handles.lambda.Ra226oneSigmaAbs = 5.415214463e-7; % half life is +/- 2 years oneSigma
handles.lambda.Pa231oneSigmaAbs = 7.114741686E-8;

handles.lambda.Slambdas = diag([handles.lambda.U238oneSigmaAbs
                                handles.lambda.U235oneSigmaAbs
                                handles.lambda.U234oneSigmaAbs
                                handles.lambda.Th230oneSigmaAbs
                                handles.lambda.Ra226oneSigmaAbs
                                handles.lambda.Pa231oneSigmaAbs]);