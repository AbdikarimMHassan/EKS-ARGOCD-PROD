resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  values = [
    file("helm-values/nginx-ingress.yaml")
  ]

  depends_on = [module.eks]
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  create_namespace = true
  namespace        = "cert-manager"

  values = [file("helm-values/cert-manager.yaml")]

  set = [
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = module.cert_manager_irsa.iam_role_arn
    }
  ]

  depends_on = [module.cert_manager_irsa, module.eks]
}

resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  chart            = "external-dns"
  create_namespace = true
  namespace        = "external-dns"

  values = [file("helm-values/external-dns.yaml")]

  set = [
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = module.external_dns_irsa.iam_role_arn
    }
  ]

  depends_on = [module.external_dns_irsa, module.eks]
}

resource "helm_release" "argo_cd_deployment" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  values = [
    file("helm-values/argo-cd.yaml")
  ]

  depends_on = [
    helm_release.nginx_ingress,
    helm_release.cert_manager,
    helm_release.nginx_ingress
  ]

  timeout = 600
}

resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  values = [
    file("helm-values/monitoring.yaml")
  ]

  depends_on = [
    helm_release.external_dns,
    helm_release.cert_manager,
    helm_release.nginx_ingress
  ]

  timeout = 1800
}