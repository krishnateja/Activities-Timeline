public class GrantActivitiesTimelineController {

    public boolean disbursementsFlag { get; set; }
    public boolean grantFlag { get; set; }
    public boolean grantReportsFlag { get; set; }
    public String grantId { get; set; }
    public String taskFilter{ get; set; }
    public Grant__c g{set;get;}
    public Grant_Report__c gr{set;get;}
    public List<SObject> d{set;get;}
    public List<Task> t{set;get;}
    public List<Task> tUpdate{set;get;}
    public string selectDate{set;get;}
    
    public superItemMap[] dataSet {get;set;}
    public superItemMapOne[] dataSetOne {get;set;}
    
    public GrantActivitiesTimelineController (){
        disbursementsFlag = true;
        grantReportsFlag  = true;   
        grantFlag = true; 
    }
    
    
    
    public PageReference onlyGR() { 
        g = [select id,name,Grant_Number__c from Grant__c where Grant_Number__c =:grantId];
        dataSet = new superItemMap[]{};
        dataSet.clear(); 
        addGrantReportActs(g);
        dataSetOne = new superItemMapOne[]{};
        
        for(integer ii=0;ii<dataSet.size();ii++){            
            if(dataSet[ii].f5 == 'future'){
                system.debug('+++++++++'+dataSet.size()); 
                dataSetOne.add(new superItemMapOne(dataSet[ii].f1,dataSet[ii].f2,dataSet[ii].f3,dataSet[ii].f4,dataSet[ii].f5,dataSet[ii].f6,dataSet[ii].f7));
                system.debug('+++++++++'+dataSetOne.size()); 
                /**     Sorting    **/                
                dateSorting(dataSetOne,1);                                                                 
            }                        
        }
        for(integer ii=0;ii<dataSet.size();ii++){                       
            if(dataSet[ii].f5 == 'pastNotCompleted'){
                dataSetOne.add(new superItemMapOne(dataSet[ii].f1,dataSet[ii].f2,dataSet[ii].f3,dataSet[ii].f4,dataSet[ii].f5,dataSet[ii].f6,dataSet[ii].f7));
                dateSorting(dataSetOne,1);
            }                       
        }for(integer ii=0;ii<dataSet.size();ii++){                        
            if(dataSet[ii].f5 == 'pastCompleted'){
                dataSetOne.add(new superItemMapOne(dataSet[ii].f1,dataSet[ii].f2,dataSet[ii].f3,dataSet[ii].f4,dataSet[ii].f5,dataSet[ii].f6,dataSet[ii].f7));                
                dateSorting(dataSetOne,2);
            }            
        } 
        return null;   
    }
    
    public PageReference makeEmpty(){
        dataSetOne = new superItemMapOne[]{};
        system.debug('------------'+dataSet);
        return null;
    }
    
    public PageReference  formDisAndGR(){
        g = [select id,name,Grant_Number__c from Grant__c where Grant_Number__c =:grantId];
        //dataSet = new superItemMap[]{}; 
        dataSet.clear(); 
        addDisbursements(g);
        addGrantReportActs(g);
        
        dataSetOne = new superItemMapOne[]{};
        
        for(integer ii=0;ii<dataSet.size();ii++){            
            if(dataSet[ii].f5 == 'future'){
                system.debug('+++++++++'+dataSet.size()); 
                dataSetOne.add(new superItemMapOne(dataSet[ii].f1,dataSet[ii].f2,dataSet[ii].f3,dataSet[ii].f4,dataSet[ii].f5,dataSet[ii].f6,dataSet[ii].f7));
                system.debug('+++++++++'+dataSetOne.size()); 
                /**     Sorting    **/                
                dateSorting(dataSetOne,1);                                                                 
            }                        
        }
        for(integer ii=0;ii<dataSet.size();ii++){                       
            if(dataSet[ii].f5 == 'pastNotCompleted'){
                dataSetOne.add(new superItemMapOne(dataSet[ii].f1,dataSet[ii].f2,dataSet[ii].f3,dataSet[ii].f4,dataSet[ii].f5,dataSet[ii].f6,dataSet[ii].f7));
                dateSorting(dataSetOne,1);
            }                       
        }for(integer ii=0;ii<dataSet.size();ii++){                        
            if(dataSet[ii].f5 == 'pastCompleted'){
                dataSetOne.add(new superItemMapOne(dataSet[ii].f1,dataSet[ii].f2,dataSet[ii].f3,dataSet[ii].f4,dataSet[ii].f5,dataSet[ii].f6,dataSet[ii].f7));                
                dateSorting(dataSetOne,2);
            }            
        }  
        system.debug('+++++++++'+dataSetOne); 
        
        return null;
    }
    
    public PageReference searchGrantDetails() {    
        
        addGrant(grantId);
        addDisbursements(g);
        addGrantReportActs(g); 

        dataSetOne = new superItemMapOne[]{};
        for(integer ii=0;ii<dataSet.size();ii++){            
            if(dataSet[ii].f5 == 'future'){
                dataSetOne.add(new superItemMapOne(dataSet[ii].f1,dataSet[ii].f2,dataSet[ii].f3,dataSet[ii].f4,dataSet[ii].f5,dataSet[ii].f6,dataSet[ii].f7));
                
                /**     Sorting    **/                
                dateSorting(dataSetOne,1);                                                                 
            }                        
        }
        for(integer ii=0;ii<dataSet.size();ii++){                       
            if(dataSet[ii].f5 == 'pastNotCompleted'){
                dataSetOne.add(new superItemMapOne(dataSet[ii].f1,dataSet[ii].f2,dataSet[ii].f3,dataSet[ii].f4,dataSet[ii].f5,dataSet[ii].f6,dataSet[ii].f7));
                dateSorting(dataSetOne,1);
            }                       
        }for(integer ii=0;ii<dataSet.size();ii++){                        
            if(dataSet[ii].f5 == 'pastCompleted'){
                dataSetOne.add(new superItemMapOne(dataSet[ii].f1,dataSet[ii].f2,dataSet[ii].f3,dataSet[ii].f4,dataSet[ii].f5,dataSet[ii].f6,dataSet[ii].f7));                
                dateSorting(dataSetOne,2);
            }            
        }  
        system.debug('-----------------'+dataSetOne);      
          
        return null;
    }
    
    public void dateSorting(List<superItemMapOne> dataSetOne,integer m){
        List<superItemMapOne> resultList = new List<superItemMapOne>();

                Map<Object, List<superItemMapOne>> objectMap = new Map<Object, List<superItemMapOne>>();

                for (superItemMapOne item : dataSetOne) {
                  if (objectMap.get(item.f6) == null) {
                    objectMap.put(item.f6, new List<superItemMapOne>());
                  }
                  objectMap.get(item.f6).add(item);
                }

                List<Object> keys = new List<Object>(objectMap.keySet());
                keys.sort();
                //if(m==2){
                    
                //}
                for(Object key : keys) {
                    resultList.addAll(objectMap.get(key));
                }
                system.debug('---------resultList11111-----------'+resultList);
                dataSetOne.clear();                
                for (Integer i = resultList.size()-1; i >= 0; i--) {
                    dataSetOne.add(resultList[i]);
                }
                   
                system.debug('---------resultList-----------'+dataSetOne);
                
                
    }
    
    public void addGrant(String grantId){
        g = [select id,name,Grant_Number__c from Grant__c where Grant_Number__c =:grantId];        
        t = [SELECT Subject,ownerId,ActivityDate,Status FROM Task WHERE WhatId =: g.id];
        dataSet = new superItemMap[]{}; 
        for(Task tc: t) {
                    user u = [select id,name,UserRoleId from user where id=: tc.ownerId];
                    UserRole ur = [select id,name from UserRole where id=: u.UserRoleId];  
                    String imgURL = checkTheImage(tc);
                    dataSet.add(new superItemMap(tc.subject,'Grant',u.name,ur.name,imgURL,tc.ActivityDate,tc.id));    
        } 
    }
    
    public void addDisbursements(Grant__c g){
        integer i= 1;
        d = [select id,name from Disbursement__c where Grant__c=:g.id]; 
        formFinalSet(d,i);  
        
        
    }
    
    public void addGrantReportActs(Grant__c g){
        integer j= 2;
        d = [select id,name from Grant_Report__c where Grant__c=:g.id];
        formFinalSet(d,j);            
    }
    
    public void formFinalSet(List<SObject> d,integer k){
        for(integer i=0;i<d.size();i++){        
                tUpdate = [SELECT Subject,ownerId,ActivityDate,Status FROM Task WHERE WhatId =: d[i].id ORDER BY ActivityDate ASC];
                for(Task tc: tUpdate) {
                    user u = [select id,name,UserRoleId from user where id=: tc.ownerId];
                    UserRole ur = [select id,name from UserRole where id=: u.UserRoleId]; 

                    String imgURL = checkTheImage(tc);                      
                    String whichEvent='';
                     
                    if(k==1){whichEvent='Disbursement';}else if(k==2){whichEvent='Grant Reports';}                                     
                    dataSet.add(new superItemMap(tc.subject,whichEvent,u.name,ur.name,imgURL,tc.ActivityDate,tc.id));  
                }
        }
    }
    
    public string checkTheImage(Task tc ){
        String imgURLc='';
        if(tc.ActivityDate < date.today() && tc.Status =='Completed'){
            imgURLc='pastCompleted';
        }else if(tc.ActivityDate < date.today() && tc.Status !='Completed'){
            imgURLc='pastNotCompleted';
        }else if(tc.ActivityDate > date.today()){
            imgURLc='future';
        }
        return imgURLc;
    }
    
    public PageReference searchGrantDetailsWithDate() {
        
        return null;
    }
    
    public class superItemMapOne{
        public String f1 {get;set;}
        public String f2 {get;set;}
        public String f3 {get;set;}
        public String f4 {get;set;}
        public String f5 {get;set;}
        public date f6 {get;set;}
        public String f7 {get;set;}
        
        public superItemMapOne(String fc1, String fc2, String fc3, String fc4,String fc5, date fc6,String fc7) {
            f1 = fc1;
            f2 = fc2;
            f3 = fc3;
            f4 = fc4;  
            f5 = fc5;  
            f6 = fc6;  
            f7 = fc7;    
            
        }

    }
    
    public class superItemMap{
        public String f1 {get;set;}
        public String f2 {get;set;}
        public String f3 {get;set;}
        public String f4 {get;set;}
        public String f5 {get;set;}
        public date f6 {get;set;}
        public String f7 {get;set;}
        
        public superItemMap(String fc1, String fc2, String fc3, String fc4, String fc5, date fc6,String fc7) {
            f1 = fc1;
            f2 = fc2;
            f3 = fc3;
            f4 = fc4;    
            f5 = fc5;  
            f6 = fc6; 
            f7 = fc7;    
            
        }

    }
}