@IsTest
public class ApprovalStepCommentControllerTest {
    
       @IsTest
    private static void test_comments() {

        ApprovalStepCommentController contr = new ApprovalStepCommentController();
        System.debug( contr.comments );

    }

}