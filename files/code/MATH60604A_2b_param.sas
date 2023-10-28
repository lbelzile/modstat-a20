proc glm data=statmod.bixicoll;
ods select ParameterEstimates;
model lognuser=celcius;
run;

proc glm data=statmod.bixicoll;
ods select ParameterEstimates;
model lognuser=farenheit;
run;

proc glm data=statmod.bixicoll;
ods select ParameterEstimates;
model lognuser=celcius farenheit;
run;
