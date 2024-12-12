/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
*
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
*
* @author Michelle Parry
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> getAllLeads() {
        List<Lead> leads = [SELECT Id, LastName, Company, Phone, Email FROM Lead];
        if (leads == null || leads.isEmpty()) {
            return new List<Lead>();
        }
        return leads;
    }

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactsByFirstName() {
        List<Contact> contacts = [SELECT Id, FirstName, LastName, Name, Phone, Email 
            FROM Contact 
            WHERE FirstName = 'John'];
        return contacts;
    }


    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List <Id> getContactIdsByLastName() {
        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName = 'Smith' OR LastName = 'Jones'];
        List<Id> contactIds = new List<Id>();
        for (Contact c : contacts) {
            contactIds.add(c.Id);
        }
        return contactIds.isEmpty() ? new List<Id>() : contactIds;
    }

    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity> getClosedWonOpportunityCountByAccount (String AccountId) {
        List<Opportunity> ClosedWonOpportunities = [SELECT Id, Name, Amount, CloseDate, StageName, AccountID 
            FROM Opportunity 
            WHERE AccountId = : AccountId 
            AND StageName = 'Closed Won'];
        return closedWonOpportunities.isEmpty() ? new List<Opportunity>() : closedWonOpportunities;
    }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getAccountCount() {
        Integer accountCount = [SELECT COUNT() FROM Account];
        return accountCount;
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id,Task> getTasksDueNextWeek() {
        Date today =  Date.today();
        Date nextWeek = today.addDays(7);
        //list tasks within 7 days
        List <Task> tasks = [SELECT Id, Subject, Status, Priority, ActivityDate
            FROM Task
            WHERE ActivityDate >= :today AND ActivityDate <= :nextWeek];
        //create map
        Map<Id, Task> taskMap = new Map<Id, Task>();
        for (Task task : tasks) {
        taskMap.put(task.Id, task);
    }
        return taskMap;
}

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact>  getContactsByEmailDomain() {
        List<Contact> contactsWithExampleDotCom = [SELECT Id, Name, email 
            FROM Contact 
            WHERE email LIKE '%example.com%'];
            
        return contactsWithExampleDotCom.isEmpty() ? new List<Contact>() : contactsWithExampleDotCom;
    }
    

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        if (String.isBlank(keyword)) {
            return new List<Opportunity>();
        }
        List <Opportunity> opportunitiesWithKeyword = [SELECT ID, Name, StageName, CloseDate ,Amount 
            FROM Opportunity
            WHERE Name Like : ('%' + keyword + '%')];
        return opportunitiesWithKeyword; // Replace null with the variable you used to store the result
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        List <Case> CaseOriginNotWebEmail = [SELECT ID, Origin
            FROM Case
            WHERE Origin NOT IN ('web', 'email')
            AND Origin != null];
        return CaseOriginNotWebEmail; // Replace null with the variable you used to store the result
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle(String leadSource, String keyword) {
        if (String.isBlank(leadSource) && String.isBlank(keyword)) {
            return new List<Lead>();
        }
        List <Lead> LeadsBySourceTitle = [SELECT Id, LeadSource, Company, FirstName, LastName, Title, Phone, Email
            FROM Lead
            WHERE (LeadSource = :leadSource OR Title LIKE :('%' + keyword + '%'))];
        return LeadsBySourceTitle;
    }    

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        // Create a list to hold the Contact LastNames
        List<String> contactLastNames = new List<String>();
        // Query the Contacts
        List<Contact> contactNamesByAccount = [SELECT LastName
            FROM Contact
            WHERE AccountId = :AccountId];
         // Loop through each Contact and add the LastName to the list
        for (Contact Contact : contactNamesByAccount ) {
            contactLastNames.add(contact.LastName);
        }
        // Return the list of Contact LastNames
        return contactLastNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for the found opportunities
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        // Use AggregateQuery to get the total revenue
        AggregateResult[] results = [SELECT SUM(Amount) totalRevenue
                                    FROM Opportunity
                                    WHERE StageName = :stage OR Amount > 10000];
        // Return the total revenue
       if (results.size() > 0){
        Decimal totalRevenue = (Decimal) results[0].get('totalRevenue');

       if (totalRevenue != null) {
            return totalRevenue;
            }
        }
        return 0;
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        List <Account> accounts = [SELECT Name, Id
            FROM Account 
            ORDER BY Name 
            LIMIT 10];
        return accounts; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        List <Opportunity> opportunities = [SELECT Amount, AccountId, CloseDate, StageName
        FROM Opportunity 
        WHERE Amount > 100000
        ORDER BY CloseDate ASC
        LIMIT 5];
    return opportunities; // Replace null with the variable you used to store the result
}
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        List <Contact> birthdatecontacts = [
            SELECT Birthdate, Name, Phone, Email
            FROM Contact
            ORDER BY Birthdate DESC
            LIMIT 3
        ];
        return birthdatecontacts; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        List <Case> casesWithStatus = [
            SELECT Status, CreatedDate, Id
            FROM Case
            WHERE status = 'open'
            ORDER BY CreatedDate
            LIMIT 10 OFFSET 5
        ];
        return casesWithStatus; // Replace null with the variable you used to store the result
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        // Create a set to hold the Case Ids
        Set<Id> caseIds = new Set<Id>();
        // Query the Cases
        List<Case> cases = [
            SELECT Id 
            FROM Case 
            WHERE AccountId = :accountId];

        // Loop through each Case and add the Id to the set
        for (Case c : cases) {
            caseIds.add(c.Id);    
        }

        return caseIds; // Replace null with the variable you used to store the result
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();
        // Query the Accounts
        List <Account> accounts = [
            SELECT ID, Name
            FROM Account
            WHERE BillingCountry != :country
        ];
        // Loop through each Account and add the Id and Name to the map
        for (Account a : accounts) {
            accountIdsToNames.put(a.Id, a.Name);
        }
        return accountIdsToNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        Contact c = [
            SELECT Account.Name
            FROM Contact
            WHERE Id = :contactId
            LIMIT 1
            ];
        return (c.Account != null) ? c.Account.Name : null; // Replace null with the variable you used to store the result
    }

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
        Account a = [
            SELECT Id, Name, (SELECT Id, Name FROM Opportunities)
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];

        return a; // Replace null with the variable you used to store the result
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        // Query the Account
        Account accounts = [
            SELECT BillingState
            FROM Account
            WHERE Id = :accountId 
              ];
        // Store the Account's BillingState
        String billingState = accounts.billingState;
        // Query the Contacts
        List<Contact> contacts = [
            SELECT Id, Name, MailingState
            FROM Contact
            WHERE MailingState = :billingState
        ];
        return contacts; // Replace null with the variable you used to store the result
    }

    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
        if (leadIds == null || leadIds.isEmpty()) {
            return new List<Account>();
        }
        // Query the Leads
        List<Lead> leads = [
            SELECT Email
            FROM Lead 
            WHERE Id IN :leadIds
        ];
        // Create a set of email domains from the Leads
        Set<String> emailDomains = new Set<String>();
        for (Lead lead : leads) {
            if (lead.Email != null) {
                String[] emailParts = lead.Email.split('@');
                if (emailParts.size() > 1) {
                    String domain = emailParts[1].toLowerCase();
                    emailDomains.add(domain);
                    emailDomains.add('www.'+ domain);
                }
            }
        }
        if (emailDomains.isEmpty()) {
            return new List<Account>();
        }
        // Query the Accounts
        List <Account> accounts = [
            SELECT Id, Name, WebSite
            FROM Account
            WHERE Website In :emailDomains
        ];
        return accounts; // Replace null with the variable you used to store the result
    }

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        // Query the original Opportunity Line Items
        List<OpportunityLineItem> originalLineItem = [
            SELECT PricebookEntryId, Quantity, UnitPrice, TotalPrice, Description, ServiceDate
            FROM OpportunityLineItem
            Where OpportunityID = :origOppId
        ];
        // Create a list to hold the new line items
        List<OpportunityLineItem> newLineItems = new List<OpportunityLineItem>();
        // Loop through each cloned Opportunity Id
        for (Id clonedOppId : cloneOppIds) {
            // Loop through each original line item
            for (OpportunityLineItem original : originalLineItem){
                // Clone the original line item and add the random number to the quantity 
                OpportunityLineItem clonedItem = new OpportunityLineItem();
            clonedItem.OpportunityId = clonedOppId;
            clonedItem.PricebookEntryId = original.PricebookEntryId;
            clonedItem.UnitPrice = original.UnitPrice;
            clonedItem.Description = original.Description;
            clonedItem.ServiceDate = original.ServiceDate;
            // Generate a random number between 1 and 3
            Double randomNumber = Math.floor(Math.random() * 3) + 1;
            clonedItem.Quantity = original.Quantity + randomNumber;
                newLineItems.add(clonedItem);
            }
        }
        insert newLineItems;
    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {        
        List<Opportunity> closedWonOpportunities = [
            SELECT OwnerId, Account.Id, Name, Account.Name, Account.Owner.Name
            FROM Opportunity
            WHERE StageName = 'Closed Won'
        ];
        
        return closedWonOpportunities; // Replace null with the variable you used to store the result
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        //Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
        List <Opportunity> closedWonOpportunities = getOpportunityDetailsForClosedWon();
        // Create a set of Account Ids from the Opportunities
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : closedWonOpportunities) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }
        // Query the Contacts
        Map<Id, Contact> accountToContactMap = new Map<Id, Contact>();
        List<Contact> contacts = [
            SELECT Id, AccountId
            FROM Contact
            WHERE AccountId IN :accountIds
            ORDER BY LastName ASC
        ];
        // Loop through each Contact and add the Account Id and Contact to the map
            for (Contact contact : contacts) {
             if (!accountToContactMap.containsKey(contact.AccountId)) {
                accountToContactMap.put(contact.AccountId, contact);
                }
            }
        // Loop through each Opportunity
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        for (Opportunity opp : closedWonOpportunities) {
            if (accountToContactMap.containsKey(opp.AccountId)) {
                opp.Primary_Contact__c = accountToContactMap.get(opp.AccountId).Id;
                opportunitiesToUpdate.add(opp);
            }
        }
                // Update the Opportunity primary contact from accountToContactMap

        // Update the Opportunities
        if (!opportunitiesToUpdate.isEmpty()) {
        update opportunitiesToUpdate;
        }
    }
}   
