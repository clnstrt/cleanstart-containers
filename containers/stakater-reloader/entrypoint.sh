#!/bin/sh
echo "🚀 Stakater Reloader – Basic Use Case"
echo "--------------------------------------"
echo "🔄 Automatically reloads Kubernetes workloads"
echo "    (Deployments, StatefulSets, DaemonSets)"
echo "    when their ConfigMaps or Secrets are updated."
echo
echo "✅ Example Workflow:"
echo "1. You mount a ConfigMap into your Deployment."
echo "2. You update the ConfigMap with new values."
echo "3. Without reloader → pods keep old values."
echo "4. With reloader → pods are restarted automatically 🎉"
echo
echo "👉 This ensures apps always run with the latest configs/secrets without manual intervention."
