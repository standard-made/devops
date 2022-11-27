package com.automation.imperfect;

import java.util.List;
import java.util.concurrent.TimeUnit;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.WebDriverWait;

public class ImperfectClass {

	public static void main(String[] args) throws InterruptedException {

		// point to chrome driver and define
		System.setProperty("webdriver.chrome.driver", "C:\\BrowserDrivers\\chromedriver.exe");
		WebDriver driver = new ChromeDriver();

		// # 1
		// launch browser, maximize, delete cookies, and add wait timers
		driver.get("http://www.google.com");
		driver.manage().window().maximize();
		driver.manage().deleteAllCookies();
		driver.manage().timeouts().pageLoadTimeout(40, TimeUnit.SECONDS);
		driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS);

		// find search element and enter keyword
		WebElement search = driver.findElement(By.name("q"));
		search.sendKeys("bacon");

		// create list from google suggested search xpath and count listed items
		List<WebElement> list = driver
				.findElements(By.xpath("//ul[@role='listbox']//li//descendant::div[@class='sbl1']"));
		System.out.println("NOTE: There are " + list.size() + " suggested keyword searches");

		// # 2
		// find 'Bacon' in suggested search list and select (prints each suggestion until 'Bacon' is found)
		for (int i = 0; i < list.size(); i++) {
			String listitem = list.get(i).getText();
			System.out.println("...searching for plain ole '" + listitem + "'");

			if (listitem.contentEquals("Bacon")) {
				System.out.println("PASS: '" + listitem + "' found in suggested searches");
				list.get(i).click();
				break;
			}
		}

		// # 3,
		// find first search result in list (always <h3> in Google)
		WebElement topBacon = driver.findElement(By.tagName("h3"));
		String topBaconHeader = topBacon.getText();
		if (topBaconHeader.contentEquals("Bacon - Wikipedia")) {
			System.out.println("PASS: '" + topBaconHeader + "' = top 'Bacon' result");
		}
		// BONUS
		// verify Sir Francis Bacon is not the first 'Bacon' result
		else if (topBaconHeader.contentEquals("Francis Bacon - Wikipedia")) {
			System.out.println("FAIL: '" + topBaconHeader + "' = top 'Bacon' result");
		}

		// # 4
		// verify nutrition facts info exists - throws exception if not found
		WebDriverWait waiter = new WebDriverWait(driver, 5000);
		waiter.until(ExpectedConditions.presenceOfElementLocated(By.xpath("//div[contains(text(),'Nutrition Facts')]")));
		WebElement nutrition = driver.findElement(By.xpath("//div[contains(text(),'Nutrition Facts')]"));
		String nutritionInfo = nutrition.getText();
		System.out.println("PASS: " + nutritionInfo + " found");

		// # 5
		// verify nutrition facts dropdown exists - throws exception if not found
		waiter.until(ExpectedConditions.presenceOfElementLocated(By.xpath("//select[@class='Ev4pye kno-nf-fs']")));
		WebElement nutritionDropDown = driver.findElement(By.xpath("//select[@class='Ev4pye kno-nf-fs']"));

		// # 6
		// select 'Bacon, baked' from dropdown options
		Select sel = new Select(nutritionDropDown);
		sel.selectByVisibleText("Bacon, baked");

		// # 7
		// confirm calories = 44
		List<WebElement> calories = driver
				.findElements(By.xpath("//tr[@class='PZPZlf kno-nf-cq']/td/span[@class='abs']"));
		for (int j = 0; j < calories.size(); j++) {
			String calorieInfo = calories.get(j).getText();

			if (calorieInfo.contentEquals("44")) {
				System.out.println("PASS: " + calorieInfo + " calories found");
				break;
			} else {
				System.out.println("FAIL: " + calorieInfo + " calories found");
			}
		}

		// leaving browser open for verifying results
		//driver.quit();
	}

}
