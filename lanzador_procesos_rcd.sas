proc datasets library=work kill nolist;
quit;

%macro deleteall;
	options nonotes;
	%local vars;

	proc sql noprint;
		select name into: vars separated by ' '
			from dictionary.macros
				where lowcase(scope)='global' 
					and substr(name,1,3) ne 'SYS';
	quit;

	%symdel &vars;
	options notes;
	%put note: macro variables deleted.;
%mend deleteall;

%deleteall;

%let ruta_codigos = C:\BBVA\RCD\codigos\;
/*%let ruta_codigos = //sasdata/00_BASELINE/Programs/CALIDAD/RCD/;*/
%global	gPeriodo mes_actual yyyymm;

%macro ejecuta_codigos(gPeriodo);

	data _null_;
		call symputx("mes_actual",put(intnx("month",input("&gperiodo.",yymmdd10.),-1,"b"),date9.));
	run;

	%include "&ruta_codigos.parametros_rcd.sas" / lrecl=5000;
	%include "&ruta_codigos.importar_insumos_rcd.sas" / lrecl=5000;
	%include "&ruta_codigos.calculos_rcd.sas" / lrecl=5000;
	%include "&ruta_codigos.tabla_final_rcd.sas" / lrecl=5000;
%mend;

/*%ejecuta_codigos(20210101);*/
/*%ejecuta_codigos(20210201);*/
/*%ejecuta_codigos(20210301);*/
/*%ejecuta_codigos(20210401);*/
/*%ejecuta_codigos(20210501);*/
/*%ejecuta_codigos(20210601);*/
/*%ejecuta_codigos(20210701);*/
/*%ejecuta_codigos(20210801);*/
%ejecuta_codigos(20210901);