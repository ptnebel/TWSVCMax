public class CustomerPortalWelcomeController {
    
    public String UserId = UserInfo.getUserId();
    public String UserName = UserInfo.getName();
    User u = [Select id,contactId,Contact.AccountId from User where id = :UserId];
    public String acctId = u.Contact.AccountId;
    public String AccountId = u.Contact.AccountId;
    
    public List<Case> cList {get;set;}
    public List<Case> ccList {get;set;} 
    public String caseURL1 {get;set;}
    public String caseURL2 {get;set;}
    
   public String keyword {get;set;}
//   public List<Question> qlist {get;set;}
//   public List<Idea> ideaList {get;set;}
   public List<Case> caseList {get;set;}
   
   public boolean showArticles {get;set;}
   public Integer returnedRows1 {get;set;}
   public Integer returnedRows2 {get;set;}
   public Integer returnedRows3 {get;set;}
   
//   public Question[] foundQuestions {get;set;}
    
    // constructor initializes page and determines whether to show datatable or error message
    public CustomerPortalWelcomeController() {
      
        Integer closecount = 0;
        Integer Highcount = 0;
        Integer Criticalcount = 0;
        Integer Mediumcount = 0;
        Integer Lowcount = 0;
        Integer casecount = 0;
        Integer tnumber = 1;
        
        cList = [Select Id, Priority, IsClosed, AccountId From Case Where AccountId =:acctId ];
        
        casecount = cList.size();
        
        for(Case cas :cList){
            if(cas.IsClosed){
                closecount += tnumber;
            }
            if(cas.Priority == 'Critical'){
                Criticalcount += tnumber;
            }
            if(cas.Priority == 'High'){
                Highcount += tnumber;
            }
            if(cas.Priority == 'Medium'){
                Mediumcount = tnumber;
            }
            if(cas.Priority == 'Low'){
                Lowcount = tnumber;
            }
        }
        
        caseURL1 = 'http://chart.apis.google.com/chart?chxl=1:|0|10|20&chf=bg,s,EAEAEA&chls=3|15&chxs=0,676767,14.833|1,676767,14.5,0,l,676767&chxt=x,y&chs=227x143&cht=gm&chtt=Cases+Closed&chds=0,20&chco=000000,FF0000|FFFF1F|00AA00&chl='+closecount+'&chd=t:'+closecount; 
    
        caseURL2 = 'http://chart.apis.google.com/chart?chs=300x150&cht=p&chco=7777CC|76A4FB|3399CC|3366CC&chd=t:'+Criticalcount+','+highcount+','+mediumcount+','+lowcount+'&chl=Critical('+Criticalcount+')|High('+highcount+')|Medium('+mediumcount+')|Low('+lowcount+')&chdl=Critical|High|Medium|Low&chp=0.367&chtt=Cases+by+Priority&chf=bg,s,EAEAEA';
        
        
        // comment out line below if you don't want to show account team
//        initAccountTeam();
        
        // comment out line below if you don't want to show contracts
//        initContracts();
        
        // comment out line below if you don't want to show recent cases
        initRecentCases();
        
        // comment out line below if you don't want to show assets
        
        // comment out line below if you don't want to show top solutions
        initTopSolutions();
        
        // comment out line below if you don't want to show ideas
//        initPopularIdeas();
        
        keyword = '';    
        
        showArticles = false;   
    }
    public pageReference performSearch(){ 
        return new pageReference ('/apex/portalsearchresults?search='+keyword);        
    }    
      
   public boolean getshowAnswers1(){
        if(this.returnedRows1>0){
            return true;
        }else{
            return false;   
        }
   }
   
   public boolean getnoAnswers1(){
        if(this.returnedRows1<1){
            return true;
                
        }else{
            return false;   
        }
   }
   public boolean getshowAnswers2(){
        if(this.returnedRows2>0){
            return true;
        }else{
            return false;   
        }
   }
   
   public boolean getnoAnswers2(){
        if(this.returnedRows2<1){
            return true;
                
        }else{
            return false;   
        }
   }
   public boolean getshowAnswers3(){
        if(this.returnedRows3>0){
            return true;
        }else{
            return false;   
        }
   }
   
   public boolean getnoAnswers3(){
        if(this.returnedRows3<1){
            return true;
                
        }else{
            return false;   
        }
   }
    
    // *** START APEX CODE TO RETRIEVE ACCOUNT TEAM.
    // comment out this section if you don't want to show account team    
    
    // wrapper class to store Account Team in a generic SObject instead of an AccountTeamMember SObject so we can show it in the portal
/*
    public class AccountTeam {
        
        public AccountTeamMember a {
                get { return a; }
                set { a = value; }
        }
        
        public String MemberName {
                get { return MemberName; }
                set { MemberName = value; }
        }
        
        public String MemberRole {
                get { return MemberRole; }
                set { MemberRole = value; }
        }
        
        public String MemberPhone {
                get { return MemberPhone; }
                set { MemberPhone = value; }
        }
        
        public String MemberEmail {
                get { return MemberEmail; }
                set { MemberEmail = value; }
        }
        
        // constructor for AccountTeam SObject
        public AccountTeam(AccountTeamMember member){
                a = member;
                MemberName = a.User.Name;
                MemberRole = a.TeamMemberRole;
                MemberPhone = a.User.Phone;
                MemberEmail = a.User.Email;                             
                
        }
        
        
    }
    
    List<AccountTeamMember> TeamMembers = new List<AccountTeamMember>();
    List<AccountTeam> Team = new List<AccountTeam>();
    
    public Boolean ShowAccountTeam {
        get { return ShowAccountTeam; }
        set { ShowAccountTeam = value; }   
    }
    
    public String AccountTeamMessage {
        get { return AccountTeamMessage; }
        set { AccountTeamMessage = value; }   
    }
    
    public void initAccountTeam() {
        
        // get list of account team members
        TeamMembers = [Select Id, TeamMemberRole, User.Name, User.Phone, User.Email From AccountTeamMember where AccountId = :AccountId];
    
        // assemble team members in generic sobject account team
        for(AccountTeamMember TeamMember : TeamMembers){
                AccountTeam member = new AccountTeam(TeamMember);
                Team.add(member);       
        }
    
        // return an error if no account team members.
       if(Team.isEmpty()){
           ShowAccountTeam = false;
           AccountTeamMessage = 'No account team members found.';
       }
       else{
           ShowAccountTeam = true;
           AccountTeamMessage = '';
       }
    }
    
    public list<AccountTeam> getAccountTeam() {
        return Team;
    }
    // *** END APEX CODE TO RETRIEVE ACCOUNT TEAM
*/
    
    // *** START APEX CODE TO RETRIEVE CONTRACTS.
    // comment out this section if you don't want to show contracts
    
    // wrapper class to store Contract in a generic SObject instead of a Contract SObject so we can show it in the portal
    public class PortalContract {
        
        public Contract c {
                get { return c; }
                set { c = value; }
        }
        
        public String ContractNumber {
                get { return ContractNumber; }
                set { ContractNumber = value; }
        }
        
        public String StartDate {
                get { return StartDate; }
                set { StartDate = value; }
        }
        
        public String EndDate {
                get { return EndDate; }
                set { EndDate = value; }
        }
        
        public String Status {
                get { return Status; }
                set { Status = value; }
        }
        
        // constructor for PortalContract SObject
        public PortalContract(Contract ct){
                c = ct;
                ContractNumber = ct.ContractNumber;
                
                // convert the Start Date to a more readable format
                Datetime Temp1 = Datetime.newInstance(ct.StartDate.year(), ct.StartDate.month(), ct.StartDate.day());
                StartDate = Temp1.format('MMMM dd, yyyy');
                
                // convert the End Date to a more readable format
                Datetime Temp2 = Datetime.newInstance(ct.EndDate.year(), ct.EndDate.month(), ct.EndDate.day());
                EndDate = Temp2.format('MMMM dd, yyyy');
                
                Status = ct.Status;                                     
        }
    }
    
    // *** START APEX CODE TO RETRIEVE CONTRACTS
    // comment out this section if you don't want to show contracts
    List<Contract> Contracts = new List<Contract>();
    List<PortalContract> PortalContracts = new List<PortalContract>();
    
    public Boolean ShowContracts {
        get { return ShowContracts; }
        set { ShowContracts = value; }   
    }
    
    public String ContractsMessage {
        get { return ContractsMessage; }
        set { ContractsMessage = value; }   
    }
    
    public void initContracts() {
        
        // get list of contracts
        Contracts = [select id,ContractNumber,StartDate,EndDate,Status from Contract where AccountId = :AccountId order by EndDate desc limit 5];
    
        // assemble contracts in generic sobject PortalContract
        for(Contract c : Contracts){
                PortalContract p = new PortalContract(c);
                PortalContracts.add(p); 
        }
    
        // return an error if no contracts.
       if(PortalContracts.isEmpty()){
           ShowContracts = false;
           ContractsMessage = 'No contracts found.';
       }
       else{
           ShowContracts = true;
           ContractsMessage = '';
       }
    }
    
    public list<PortalContract> getContracts() {
        return PortalContracts;
    }
    // *** END APEX CODE TO RETRIEVE CONTRACTS
    

    // *** START APEX CODE TO RETRIEVE MY RECENT CASES.
    // comment out this section if you don't want to show recent cases
    public List<Case> RecentCases; 
    public List<SVMXC__Installed_Product__c> installedProducts {get;set;}
    
    public Boolean ShowRecentCases {
        get { return ShowRecentCases; }
        set { ShowRecentCases = value; }   
    }
    
    public String RecentCasesMessage {
        get { return RecentCasesMessage; }
        set { RecentCasesMessage = value; }    
    }
    
    public void initRecentCases() {
        
      RecentCases = [select id,CaseNumber,Subject,Status,LastModifiedDate from Case where ContactId = :u.ContactId order by LastModifiedDate desc limit 3];
      installedProducts = [Select SVMXC__Serial_Lot_Number__c, SVMXC__Product_Name__c, SVMXC__Date_Installed__c, Name From SVMXC__Installed_Product__c WHERE SVMXC__Contact__c =:u.ContactId order by LastModifiedDate limit 10];
      //System.assert(installedProducts.size() == 1);
        // return an error if no recent cases.
       if(RecentCases.isEmpty()){
           ShowRecentCases = false;
           RecentCasesMessage = 'No cases found for '+UserName;
       }
       else{
           ShowRecentCases = true;
           RecentCasesMessage = '';
       }
    }
    
    public list<Case> getRecentCases() {
        return RecentCases;
    }
    // *** END APEX CODE TO RETRIEVE MY RECENT CASES
    
    // *** START APEX CODE TO RETRIEVE MY ASSETS.
    // comment out this section if you don't want to show assets
    public List<Asset> Assets; 
    
    public Boolean ShowAssets {
        get { return ShowAssets; }
        set { ShowAssets = value; }   
    }
    
    public String AssetsMessage {
        get { return AssetsMessage; }
        set { AssetsMessage = value; }    
    }
    
    public void initAssets() {
        
        Assets = [select id,Name,SerialNumber,InstallDate,UsageEndDate,Status from Asset where ContactId = :u.ContactId order by SerialNumber desc limit 3];
    
        // return an error if no assets.
       if(Assets.isEmpty()){
           ShowAssets = false;
           AssetsMessage = 'No assets found for '+UserName;
       }
       else{
           ShowAssets = true;
           AssetsMessage = '';
       }
    }
    
    public list<Asset> getAssets() {
        return Assets;
    }
    // *** END APEX CODE TO RETRIEVE MY ASSETS
    
    // *** START APEX CODE TO RETRIEVE TOP SOLUTIONS.
    // comment out this section if you don't want to show top solutions
    public List<Solution> TopSolutions; 
    
    public Boolean ShowTopSolutions {
        get { return ShowTopSolutions; }
        set { ShowTopSolutions = value; }   
    }
    
    public String TopSolutionsMessage {
        get { return TopSolutionsMessage; }
        set { TopSolutionsMessage = value; }    
    }
    
    public void initTopSolutions() {
    
        TopSolutions = [select id,SolutionName,TimesUsed,LastModifiedDate from Solution order by TimesUsed desc limit 3];
    
        // return an error if no solutions.
       if(TopSolutions.isEmpty()){
           ShowTopSolutions = false;
           TopSolutionsMessage = 'No solutions found.';
       }
       else{
           ShowTopSolutions = true;
           TopSolutionsMessage = '';
       }
    }
    
    public list<Solution> getTopSolutions() {
        return TopSolutions;
    }
    // *** END APEX CODE TO RETRIEVE TOP SOLUTIONS
    
    // *** START APEX CODE TO RETRIEVE IDEAS
    // comment out this section if you don't want to show ideas
/*
    public List<Idea> PopularIdeas; 
    
    public Boolean ShowPopularIdeas {
        get { return ShowPopularIdeas; }
        set { ShowPopularIdeas = value; }   
    }
    
    public String PopularIdeasMessage {
        get { return PopularIdeasMessage; }
        set { PopularIdeasMessage = value; }    
    }
    
    public void initPopularIdeas() {
    
        PopularIdeas = [select id,Title,Category,VoteTotal from Idea order by VoteTotal desc limit 3];
    
        // return an error if no ideas.
       if(PopularIdeas.isEmpty()){
           ShowPopularIdeas = false;
           PopularIdeasMessage = 'No ideas found.';
       }
       else{
           ShowPopularIdeas = true;
           PopularIdeasMessage = '';
       }
    }
    
    public list<Idea> getPopularIdeas() {
        return PopularIdeas;
    }
    // *** END APEX CODE TO RETRIEVE IDEAS
*/

	public static testmethod void test(){
		Account a = new Account(Name='Test'); insert a;
		Contact c = new Contact(FirstName='Contact', LastName='Last', AccountId=a.id); insert c;		
		String UserId = UserInfo.getUserId();
    	String UserName = UserInfo.getName();
    	User u = [Select id,contactId,Contact.AccountId from User where ContactId!=null AND Profile.Name like '%Customer%' limit 1];
    	CustomerPortalWelcomeController customerclass = new CustomerPortalWelcomeController();
    	customerclass.getAssets(); customerclass.getContracts(); customerclass.getRecentCases(); customerclass.getTopSolutions();
    	customerclass.getnoAnswers1(); customerclass.getnoAnswers2(); customerclass.getnoAnswers3();
    	customerclass.getshowAnswers1(); customerclass.getshowAnswers2(); customerclass.getshowAnswers3();    	
    	customerclass.initAssets(); customerclass.initContracts(); customerclass.initRecentCases(); customerclass.initTopSolutions();
    	customerclass.performSearch();
    	
	}
}