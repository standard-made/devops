STACK - RUN ON WINDOWS 10
-----------------------------------------------
1. Java 16 - https://www.oracle.com/java/technologies/javase-jdk16-downloads.html

2. Eclipse IDE - https://www.eclipse.org/downloads/

3. Selenium Jar - https://www.selenium.dev/downloads/ (get latest stable version)
	a. in Eclipse, right click on project foler and select Build Path -> Configure Build Path
	b. select the Libraries tab and select Class Path
	c. select option to Add External JARs and select the previously downloaded Selenium jar file and import

4. Chrome browser driver - https://sites.google.com/a/chromium.org/chromedriver/ (select version that is not higher than your local version of Chrome)

SETPS TO EXECUTE/RUN AUTOMATION
-----------------------------------------------
You can run this in 2 ways - both methods require that you place the attached imperfect.jar in the following directory > C:\AUTOMATION\WORKSPACE\IMPERFECT\
Both methods also display the results in the cmd terminal window - so do not close

METHOD 1) from your OS terminal (type cmd into your Windows search bar to open the command line interface) type the commands below. 
This will change the current directory to point to where the jar file is located and run it using the java -jar command. Test results are written to the CLI during execution:
	a. java -version
			use this to verify you have java 16 installed (not sure if code compiled with jdk-16 is backwards compatable with lower version of java, so this is suggested)
	b. cd <folder path containing jar file>
	d. java -jar imperfect.jar
	
METHOD 2) Double click the attached RUN_ME-imperfect-foods.bat and enjoy!
	
NOTE: I did not close the browser after the test run so you can verify the Google page results. Test results are shown in the CLI.

