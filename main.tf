provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-local-dev"
}

resource "kubernetes_namespace" "devops_ns" {
  metadata {
    name = "devops-task-nextjs-main"
    labels = {
      environment = "development"
      project     = "devops-task"
    }
  }
}

resource "kubernetes_deployment" "devops_task" {
  metadata {
    name      = "devops-task"
    namespace = kubernetes_namespace.devops_ns.metadata[0].name
    labels = {
      app = "devops-task"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "devops-task"
      }
    }

    template {
      metadata {
        labels = {
          app = "devops-task"
        }
      }

      spec {
        container {
          name  = "devops-task"
          image = "${var.docker_image_name}:${var.docker_image_tag}"

          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "devops_task_service" {
  metadata {
    name      = "devops-task-service"
    namespace = kubernetes_namespace.devops_ns.metadata[0].name
    labels = {
      app = "devops-task"
    }
  }

  spec {
    selector = {
      app = "devops-task"
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 3000
    }

    type = "ClusterIP"
  }
}

variable "docker_image_name" {
  description = "The name of the Docker image"
  type        = string
  default     = "localhost:5001/devops-task"
}

variable "docker_image_tag" {
  description = "The tag of the Docker image"
  type        = string
  default     = "1.0"
}
