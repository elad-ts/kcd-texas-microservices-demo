# kcd-texas-microservices-demo

<img src="kcd-texas.webp" alt="KCD Texas Microservices Demo" width="500" />

## From Kubernetes to Chaos Mesh: How CNCF Projects Redefine Platform Resilience

**Elad Hirsch**  
Tech Lead, CTO Office, TeraSky

Platform engineering is evolving, and resilience is no longer optional. How can you go beyond traditional approaches to observability, reliability, and automation? Enter CNCF projects like Kubernetes, ArgoCD, Chaos Mesh, and Pixie. By combining these tools, platform teams can build systems that are not only scalable but also chaos-ready and deeply observable—with no added instrumentation.

In this talk, we'll explore how Pixie leverages eBPF to provide real-time observability, how Chaos Mesh enables proactive failure testing, and how ArgoCD transforms deployment practices. Using real-world examples, we'll demonstrate how these projects work together to simplify platform operations and improve reliability.

Whether you're managing Kubernetes clusters, optimizing CI/CD pipelines, or firefighting production incidents, this talk delivers actionable insights. Learn how to integrate these CNCF tools into your platform stack and stay ahead of complexity.

## Demo Scenario

This repository demonstrates how CNCF tools work together to build resilient microservice platforms:

1. **Microservices Demo Application**: A multi-service application deployed on Kubernetes
2. **ArgoCD**: Managing GitOps-based deployments
3. **Chaos Mesh**: Introducing controlled chaos to test system resilience
   - Network latency injection into the product catalog service
   - HTTP delays in the frontend service
4. **Pixie**: Real-time observability without instrumentation
   - Analyzing latency spikes and unexpected behavior
   - Troubleshooting the mysterious "100ms delay = 1.1-1.8s latency" issue

## Demo Steps

The demo script (`./demo/run-demo.sh`) walks through the following steps:

1. **Setup and Environment Check**
   - Clean up any existing chaos experiments
   - Verify Kubernetes cluster and running services

2. **Deployment Verification**
   - Access ArgoCD dashboard to view deployments
   - Check Kubernetes nodes and pods
   - Verify microservices are running correctly
   - Open the online store frontend

3. **Observability Setup**
   - Confirm Pixie agents are running
   - Access Pixie dashboard for real-time monitoring

4. **Chaos Engineering**
   - Verify Chaos Mesh components are running
   - Review RBAC permissions for Chaos Mesh
   - Generate authentication token for Chaos Mesh dashboard
   - Establish baseline performance with load testing
   - Inject network latency into product catalog service
   - Observe system behavior under induced latency
   - Remove latency and verify recovery
   - Inject HTTP delays into frontend service
   - Observe cascading effects across the system

5. **Anomaly Investigation**
   - Identify unusual latency amplification (100ms injection causing 1.1-1.8s delays)
   - Use Pixie for deep latency analysis without code instrumentation
   - Trace request paths to identify bottlenecks and cascading failures

Each step demonstrates how these CNCF tools combine to provide a comprehensive platform for building, observing, testing, and troubleshooting resilient microservice architectures.