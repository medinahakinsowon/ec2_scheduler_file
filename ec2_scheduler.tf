


resource "aws_iam_role" "scheduler" {
 name = "scheduler_role"
 
 assume_role_policy = jsonencode({
     Version = "2017-10-17"
     Statement = [
         {
           Action = "sts:AssumeRole"
           Effect = "Allow"
           Principal = {
            Service = "Scheduler.amazonaws.com"
            }
         
         }
    ]
  })
                                                                                                                        
} 

resource "aws_iam_policy" "scheduler_policy" {
 name = "scheduler_policy"
 description = "Policy for scheduler to stop and start EC2 instances"

 policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
          Action = [
             "ec2:StartInstances",
             "ec2:StopInstances"
           ],
          Effect = "Allow"
          Resource = "*"
         }
       ]
})

}

resource "aws_iam_role_policy_attachment" "scheduler_policy_attach" {
   role = aws_iam_role.scheduler.name
   policy_arn = aws_iam_role.scheduler_policy.arn
}
    




resource "aws_scheduler_schedule" "start_ec2_morning" {
   name = "start-ec2-morning

   #This cron expression will run 6pm UTC on weekdays
   schedule_expression = "cron(0 7 ? * MON-FRI *)"   
   target {
      arn = "arn:aws:scheduler:::aws-sdk:ec2:startInstances"
      role_arn = aws_iam_role.scheduler.arn

      input = jsonencode({
        InstanceIds = var.instance_ids
      })
   }

  flexible_time_window {
    mode = "OFF"
  }
}
 

resource "aws_scheduler_schedule" "stop_ec2_evening" {
   name = "stop-ec2-evening"
   
   #This cron expression will run 6pm UTC on weekdays
   schedule_expression = "cron(0 18 ? * MON-SUN *)"
   
   target {
      arn = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
      role_arn = aws_iam_role.scheduler.arn

      input = jsonencode({
        InstanceIds = var.instance_ids
      })
   }

  flexible_time_window {
    mode = "OFF"
  }
}
  
    
    
      
   
