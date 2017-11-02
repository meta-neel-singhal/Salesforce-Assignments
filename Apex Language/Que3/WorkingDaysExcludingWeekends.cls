public class WorkingDaysExcludingWeekends {
	//Create a function which take 2 dates as argument and return number of working days between two days excluding both days(Saturday and Sunday is nonworking)
    public static Integer noOfWorkingDays(Date date1, Date date2) {
        Integer workingDays = 0;
        Datetime dt;
        
        if(date1 == null || date2 == null) {
            return workingDays;
        }
        if (date1 > date2) {
           Date tempDate = date1;
           date1 = date2;
           date2 = tempDate;
       }
        while (date1 <= date2) {
            dt = DateTime.newInstance(date1, Time.newInstance(0, 0, 0, 0));    
            if (dt.format('E') != 'Sat' && dt.format('E') != 'Sun') {
                workingDays++;
            }
            date1 = date1.addDays(1);
        }
    	System.debug(workingDays);
        return workingDays;
    }   
}

/*
public class WorkingDaysExcludingWeekends {

   private static final List<Boolean> isWorking = new List<Boolean>{True, True, True, True, True, False, False};
   private static final Date firstMonday = Date.newInstance(1900, 1, 1);
   private static final Integer workingDaysInWeek = 5;
   
   public static Integer getWorkingDaysBetween(Date startDate, Date EndDate) {
       if (startDate == null || EndDate == null) {
           return 0;
       }
       
       if (startDate > EndDate) {
           Date tempDate = startDate;
           startDate = EndDate;
           EndDate = tempDate;
       }
       
       Integer totalDays = startDate.daysBetween(EndDate);
       
       if (totalDays == 0) {
           return isWorking[getDayOfWeek(startDate)] ? 1 : 0;
       } else {
           Integer wholeWeeks = Math.floor(totalDays / 7).intValue();
           Integer workingDays = wholeWeeks * workingDaysInWeek;
           Integer dayOfWeek = getDayOfWeek(endDate);
           
           for(Integer remainder = Math.mod(totalDays, 7); remainder >= 0; remainder--){
               if(isWorking[dayOfWeek]){
                   workingDays++;
               }
               dayOfWeek--;
               if(dayOfWeek < 0){
                   dayOfWeek = 6;
               }
           }
           
           return workingDays;
       }   
   }
      
   private static Integer getDayOfWeek(Date value){
       return Math.mod(firstMonday.daysBetween(value), 7);
   }
}
*/