# ArgoCD Applications

## Application 동기화 전략

해당 레포지토리 `main` Branch의 `argocd-applications` directory에 있는 Application(ArgoCD CRD)를 자동으로 동기화한다.


## 계정정보

각 팀별로 계정을 부여 및 관리
- be
- fe
- devops
- ...

## 사용법

아래 예시를 참고하여 동기화시키고 싶은 Source를 지정하여 Application 생성 후 `main` Branch로 Pull Request

```
# 예시
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: argo-workflow-staging # Application Name
  namespace: default # Appication Namespace
spec:
  project: devops # Project, 계정에 따라 맞게 설정
  destination:
    name: cluster-dev # Cluster Name: dev, staging, production
    namespace: argo-workflow # Namespace
  source:
    path: iac/argo/staging # Path: 동기화시킬 소스코드 위치
    repoURL: git@github.com:ORGANIZATION/argocd.git # 동기화시킬 Repository URL 참고로 ssh형식만 지원
    targetRevision: main # branch
  syncPolicy:
    syncOptions:     # Sync options which modifies sync behavior
    - Validate=false # disables resource validation (equivalent to 'kubectl apply --validate=false') ( true by default ).
    - CreateNamespace=true # Namespace Auto-Creation ensures that namespace specified as the application destination exists in the destination cluster.
    - PrunePropagationPolicy=foreground # Supported policies are background, foreground and orphan.
    - PruneLast=true # Allow the ability for resource pruning to happen as a final, implicit wave of a sync operation
    - ApplyOutOfSyncOnly=true
    - Replace=true
    # The retry feature is available since v1.7
    retry:
      limit: 5 # number of failed sync attempt retries; unlimited number of attempts if less than 0
      backoff:
        duration: 5s # the amount to back off. Default unit is seconds, but could also be a duration (e.g. "2m", "1h")
        factor: 2 # a factor to multiply the base duration after each failed retry
        maxDuration: 3m # the maximum amount of time allowed for the backoff strategy
```
파일위치는 각 계정에 맞는 Directory에 위치하도록 한다.

예시) be 계정을 사용할경우 `argocd-applications/be`에 `application`을 생성한다.

