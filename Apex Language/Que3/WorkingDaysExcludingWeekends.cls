/* 
* Create a function which take 2 dates as argument and return number of working days between two days excluding
* both days(Saturday and Sunday is nonworking).
*/
public class WorkingDaysExcludingWeekends {
    public static Integer noOfWorkingDays(Date date1, Date date2) {
        Integer workingDays = 0;
        Datetime date_time;
        
        if(date1 == null || date2 == null) {
            return workingDays;
        }
        // If date2 is smaller than date1, swap the values to get number of working days between them.
        if (date1 > date2) {
            Date tempDate = date1;
            date1 = date2;
            date2 = tempDate;
        }
        
        while (date1 <= date2) {
            date_time = DateTime.newInstance(date1, Time.newInstance(0, 0, 0, 0));    
            if (date_time.format('E') != 'Sat' && date_time.format('E') != 'Sun') {
                workingDays++;
            }
            date1 = date1.addDays(1);
        }
        return workingDays;
    }   
}