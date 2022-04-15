@set LIBPATH=c:\tools\codenarc
@set RULSETS="file:c:\tools\codenarc.groovy"
@set FILEPATH=%1

java -cp %LIBPATH%\* -Dfile.encoding="UTF-8" org.codenarc.CodeNarc -report=org.codenarc.report.CompactTextReportWriter:stdout -rulesetfiles=%RULSETS% -includes="**/%FILEPATH:\=/%" 2>&1
