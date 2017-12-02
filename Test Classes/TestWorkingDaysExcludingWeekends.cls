@isTest
private class TestWorkingDaysExcludingWeekends {
    @isTest
    static void testWorkingDaysForCorrectDateSequence() {
        Date startDate = Date.newInstance(2017, 10, 31);
        Date endDate = Date.newInstance(2017, 11, 6);
        Integer workingDays = WorkingDaysExcludingWeekends.noOfWorkingDays(startDate, endDate);
        System.assertEquals(5, workingDays, 'Number of working days must be 5.');
    }
    
    @isTest
    static void testWorkingDaysForReverseDateSequence() {
        Date startDate = Date.newInstance(2017, 10, 22);
        Date endDate = Date.newInstance(2017, 10, 6);
        Integer workingDays = WorkingDaysExcludingWeekends.noOfWorkingDays(startDate, endDate);
        System.assertEquals(11, workingDays, 'Number of working days must be 11.');
    }
    
    @isTest
    static void testWorkingDaysForOneWorkingDay() {
        Date startDate = Date.newInstance(2017, 10, 3);
        Date endDate = Date.newInstance(2017, 10, 3);
        Integer workingDays = WorkingDaysExcludingWeekends.noOfWorkingDays(startDate, endDate);
        System.assertEquals(1, workingDays, 'Number of working days must be 1.');
    }  
    
    @isTest
    static void testWorkingDaysForOneNonWorkingDay() {
        Date startDate = Date.newInstance(2017, 10, 1);
        Date endDate = Date.newInstance(2017, 10, 1);
        Integer workingDays = WorkingDaysExcludingWeekends.noOfWorkingDays(startDate, endDate);
        System.assertEquals(0, workingDays, 'Number of working days must be 0.');
    }
    
    @isTest
    static void testForNullDates() {
        Date startDate = Date.newInstance(2017, 10, 3);
        Date endDate;
        Integer workingDays = WorkingDaysExcludingWeekends.noOfWorkingDays(startDate, endDate);
        System.assertEquals(0, workingDays, 'Number of working days must be 0.');
    }
}