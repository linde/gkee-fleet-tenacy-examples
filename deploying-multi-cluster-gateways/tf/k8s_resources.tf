

locals {
  mcg_service_0 = "mcg-0"
  mcg_service_1 = "mcg-1"
}

resource "helm_release" "worker_0" {
  provider = helm.mcg_0

  name  = "worker"
  chart = "./charts/worker"

  set {
    name  = "cluster"
    value = local.mcg_service_0
  }

  depends_on = [
    time_sleep.post_mci,
    time_sleep.post_rolebindings,
  ]
}

resource "helm_release" "worker_1" {
  provider = helm.mcg_1

  name  = "worker"
  chart = "./charts/worker"

  set {
    name  = "cluster"
    value = local.mcg_service_1
  }

  depends_on = [
    time_sleep.post_mci,
    time_sleep.post_rolebindings,
  ]
}


resource "helm_release" "hub" {
  provider = helm.hub

  name  = "hub"
  chart = "./charts/hub"

  set {
    name  = "service0"
    value = local.mcg_service_0
  }
  set {
    name  = "service1"
    value = local.mcg_service_1
  }

  depends_on = [
    helm_release.worker_0,
    helm_release.worker_1
  ]
}
