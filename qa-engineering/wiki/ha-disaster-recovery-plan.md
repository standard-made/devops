**<h1> Standard DISASTER RECOVERY PLAN </h1>**
![standard-wiki.png](/src/standard-wiki.png)


## <span style="color:#555555"><u> **OVERVIEW** </u></span>
The Standard Disaster Recovery Plan (DRP), defined in collaboration with internal stakeholders, will encompass the various testing methods for validating critical business systems, infrastructure, and failover solutions within the Standard High Availability (HA) project scope. Tests are defined and prioritize by the project group and executed in accordance with the specified test references and project timelines.

#16230



## <span style="color:#555555"><u> **POINTS OF CONTACT** </u></span>
For all HA and DR related inquires or issues, please contact the associated personnel for general information or support.

:taco: **QA Engineering:**<span style="color:gold"> kit@made.llc </span>



## <span style="color:#555555"><u> **TEST PLAN** </u></span>
Standard is committed to ensuring that the Disaster Recovery Plan (DRP) is functional. The DRP and Test Plan should be re-verified whenever system-wide outages or failures occur, and when changes are made to the HA infrastructure in order to ensure that Standard's DRP is still effective. Testing the DRP will be carried out as follows: 

1) **Walkthrough** - Team members verbally go through the specific steps as documented in the plan to confirm effectiveness, identify gaps, bottlenecks or other weaknesses. This test provides the opportunity to review a plan with a larger subset of people, allowing the DRP project manager to draw upon a correspondingly increased pool of knowledge and experiences. Staff should be familiar with procedures, equipment, and offsite facilities (if required).
   - Verify [Standard Failover Process]()

2) **Simulation** - A disaster is simulated so normal operations will not be interrupted. Hardware, software, personnel, communications, procedures, supplies and forms, documentation, transportation, utilities, and alternate site processing should be thoroughly tested in a simulation test. However, validated checklists can provide a reasonable level of assurance for many of these scenarios. Analyze the output of the previous tests carefully before the proposed simulation to ensure the lessons learned during the previous phases of the cycle have been applied. 

3) **Parallel Testing** - A parallel test can be performed in conjunction with the checklist test or simulation test. Under this scenario, historical transactions, such as the prior business day's transactions are processed against preceding day's backup files at the contingency processing site or hot site. All reports produced at the alternate site for the current business date should agree with those reports produced at the alternate processing site. 

4) **Regression Testing** - An automated regression test is configured to run on a VM using the active region (EastUS or WestUS) and will be used to test the effectiveness of the Disaster Recovery procedures by validating firewalls, connections, networking traffic, database activity, and base functionality of the PartnerPortal website and APIs. 
   - Run [PartnerPortal Regression Pipeline]() 
   - Run [Postman Partner API Regression Collection]() 

5) **Full-Interruption Testing** - A full-interruption test activates the total DRP. The test is likely to be costly and could disrupt normal operations, and therefore should be approached with caution. The importance of due diligence with respect to previous DRP phases cannot be overstated. Any gaps in the DRP that are discovered during the testing phase will be addressed by the Disaster Recovery Lead as well as any resources that he/she will require. 



## <span style="color:#555555"><u> **ACTIVE TIMELINE** </u></span>
The active Disaster Recovery Timeline is intended to track dates, times, and events of system outages, testing occurrences and approvals, and changes made to the Standard HA infrastructure. In the event of a catastrophic failure, the Standard DevProjects team will be responsible for the execution of the DRP and any subsequent testing/sign-off that may be required in order to verify all critical systems are running as expected - within the recommended 24hr time period. 

::: mermaid
gantt
title Disaster Recovery Timeline
dateFormat YYYY-MM-DD

section Event
Implementation :active, a1, 2022-08-15, 1d

section Status
Active/Passive :milestone, 2022-08-16, 0d

section Testing
🌮 :crit, done, after a1, 1d

section Approval
Sign-Off :milestone, 0d

:::

### <span style="color:#555555"><u> **EVENTS** </u></span>
[enter event dates here]

- Implementation - 8/15/2022 | **<span style="color:gold">COMPLETE</span>**
   - [Active/Passive] - [WestUS/EastUS]

### <span style="color:#555555"><u> **OUTAGES** </u></span>
[enter planned and unplanned outage dates here]

- Planned Outage - TBD
   - Testing

### <span style="color:#555555"><u> **TESTING** </u></span>
[enter testing and sign-off dates here]

- Planned Test - TBD
   - Sign-Off by: DevelopmentTeam@made.llc
