**<h1> STANDARD: OBJECT NAMEMAPPING w/TESTCOMPLETE </h1>**
![standard-automation.png](/src/standard-automation.png)



## <span style="color:#555555"><u> **OVERVIEW** </u></span>
The Name Mapping repository stores object identification information separately from tests making test shorter and easier to read and maintain. Name Mapping stores all of the objects in our tested applications that our automated tests use. For each on-screen object, the Name Mapping repository has an Alias (a descriptive name used in tests), the object’s position in the application’s object hierarchy (DOM - document object model), the criteria by which TestComplete identifies the object in the application uniquely, and (optionally) an image. 


## <span style="color:#555555"><u> **POINTS OF CONTACT** </u></span>
When issues arise for any of the below mentioned areas, please contact the associated personnel for support and troubleshooting.

:taco: **QA Engineering:**<span style="color:gold"> kit@made.llc </span>



## <span style="color:#555555"><u> **BEST PRACTICES** </u></span>
Each tested application should maintain it's own NameMpping repository within the tested application's TestComplete Project. Objects should be uniquely identified using multiple xpath/css conditions, object properties, or dynamic **project** variables. See Smartbear references below for more information:

Merging - [reference](https://support.smartbear.com/testcomplete/docs/testing-with/object-identification/name-mapping/how-to/merge.html)
NameMapping - [reference](https://support.smartbear.com/testcomplete/docs/testing-with/object-identification/name-mapping/index.html)

![nameMapping.png](/src/assets/nameMapping.png)


**NOTE:** All NameMapping changes should conform to the existing naming format and object hierarchy of each individual project. All commits of the `NameMapping.tcNM` and `TypeInfo.dat` files to the automation repository should be approved and pushed by the individuals reference as the NameMapping points of contact (above).



## <span style="color:#555555"><u> **OBJECT IDENTIFICATION** </u></span> 
The object identification criteria that the repository stores and that TestComplete uses to search for objects in the applications can be:
- [Property-value pairs](https://support.smartbear.com/testcomplete/docs/testing-with/object-identification/name-mapping/basic-mapping-criteria.html). For example, `ObjectType=Page`, `URL=http://example.com`.
- [Conditional expressions](https://support.smartbear.com/testcomplete/docs/testing-with/object-identification/name-mapping/conditional-mapping-criteria.html). For example, `WndCaption = Open` OR `Select File`.
- [Selectors](https://support.smartbear.com/testcomplete/docs/testing-with/object-identification/name-mapping/selectors.html) (for web and mobile applications) For web applications, it can be XPath expressions and CSS selectors, for example, `//input[@id='instasearch']` or `#instasearch`. For mobile applications, it can be the object class name, accessibility identifier, or an XPath expression, for example, `XCUIElementTypeStatusBar` or `//*[@name="Orders"]`.
- [Extended search](https://support.smartbear.com/testcomplete/docs/testing-with/object-identification/name-mapping/extended-search.html). Search for an object on all the levels down the object hierarchy rather than just on the current level.
- [Required child objects](https://support.smartbear.com/testcomplete/docs/testing-with/object-identification/name-mapping/required-children.html). Search for an object that has specific child objects.

To customize the default identification properties that TestComplete uses to map objects, you can create unique templates. 



## <span style="color:#555555"><u> **OBJECT HIERARCHY** </u></span> 
- <span style="color:red">**OLD:**</span> `Sys.Browser("chrome").Page("https://portal.standard.com/accounts/wallet").FindElement("//table[contains(@class, 'list-table')]//tbody/tr[1]");`
- <span style="color:green">**NEW:**</span> `NameMapping.Sys.Browser.sBO_Accounts.Profiles.Results.Top`
- <span style="color:green">**NEW:**</span> `Aliases.Browser.sBO_Accounts.Profiles.Results.Top`
::: mermaid
graph TD
A[Sys.Browser] -->|URL| B[sAuth]
A -->|URL| C[sBackOffice]
A -->|URL| D[sPortal]

B -->|Area| BA[Auth]
BA -->|Object| BB[Login]

C -->|Page| C1[_Main]
C1 -->|Area| C1A[Menu]
C1A -->|Object| C1B[User]

C -->|Page| C2[_Accounts]
C2 -->|Section| C2A[Profiles]
C2A -->|Area| C2B[Results]
C2B -->|Object| C2C[Row1]

D -->|Page| D1[_Main]
D1 -->|Section| D1A[Nav]
D1A -->|Area| D1B[Transfers]
D1B -->|Object| D1C[sendFX]
D1C --> |Form| D1D[Quote]
D1C --> |Form| D1E[Trade]
D1C --> |Form| D1F[Payment]
D1D --> |Section| D1G[From]
D1G --> |Area| D1H[AccountList]
D1H --> |Object| D1I[Account]
D1E --> D1J[...]
D1F --> D1K[...]

E[Sys.Browser] --> |URL| F[sMade]
F --> |Page| F1[_Main]
F --> |iFrame| F2[_Transaction]
F1 --> F1A[...]
F2 --> F2A[...] 
:::