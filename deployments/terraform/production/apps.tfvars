application_name         = "Mysiloam-prod-ecs-hello-world"
short_name               = "Mysiloam-iac-ecs-hello-world"
region                   = "ap-southeast-3"
environment              = "prod"
subnet_ids               = ["subnet-0713bb74c9699bf25", "subnet-0be21621cf454b9c4", "subnet-07a7e59a6891c893e"]
ecs_cluster_name         = "Mysiloam-prod-ecs-iac"
service_name             = "Mysiloam-prod-ecs-hello-world"
requires_compatibilities = ["EC2"]
volume                   = {}
cpu                      = 256
memory                   = 512
container_port           = 3000
container_definitions = {
  Mysiloam-prod-ecs-hello-world = {
    image = "{{ image }}"
    port_mappings = [
      {
        name          = "mysiloam-prod-ecs-hello-world"
        containerPort = 3000
        protocol      = "tcp"
        appProtocol   = "http"
      }
    ]
    secrets = [
      {
        name      = "TELECHAT_PAGE_ID",
        valueFrom = "arn:aws:secretsmanager:ap-southeast-3:672275484883:secret:Mysiloam/prod/awssm/mysiloam-api-lslWI9:TELECHAT_PAGE_ID::"
      },
    ]
    enable_cloudwatch_logging = true
    readonly_root_filesystem  = false
  }
}
load_balancer = {
  service = {
    target_group_arn = "arn:aws:elasticloadbalancing:ap-southeast-3:672275484883:targetgroup/Mysiloam-iac-nlb-hello-world/0e44a6a970c4fb5b"
    container_name   = "Mysiloam-prod-ecs-hello-world"
    container_port   = 3000
  }
}
capacity_provider_strategy = {
  mysiloam-ec2-ondemand-small = {
    capacity_provider = "mysiloam-ec2-ondemand"
    weight            = 1
    base              = 1
  }
}
task_definition_placement_constraints = {
  placement_constraint_1 = {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [ap-southeast-3a, ap-southeast-3b, ap-southeast-3c]"
  }
}
enable_autoscaling       = true
desired_count            = 3
autoscaling_min_capacity = 3
autoscaling_max_capacity = 9
autoscaling_policies = {
  cpu = {
    policy_type = "TargetTrackingScaling"
    target_tracking_scaling_policy_configuration = {
      predefined_metric_specification = {
        predefined_metric_type = "ECSServiceAverageCPUUtilization"
      }
      target_value = 70
    }
  }
  memory = {
    policy_type = "TargetTrackingScaling"
    target_tracking_scaling_policy_configuration = {
      predefined_metric_specification = {
        predefined_metric_type = "ECSServiceAverageMemoryUtilization"
      }
      target_value = 70
    }
  }
}
tags = {
  Name               = "Mysiloam-prod-ecs-iac"
  Environment        = "prod"
  OwnerTeam          = "mysiloam"
  DepartmentID       = "mysiloam"
  DataClassification = "clinical"
  ManagedVia         = "Terraform"
  ProvisionedBy      = "SoftwareOne-AWS"
}