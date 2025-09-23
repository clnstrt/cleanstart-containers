<p><strong>Container Documentation for Minio-Operator-Sidecar</strong></p>
<p>MinIO Operator Sidecar container provides essential functionality for managing and orchestrating MinIO deployments in Kubernetes environments. It facilitates automated operations, monitoring, and maintenance of MinIO instances while ensuring high availability and scalability for enterprise object storage solutions.</p>
<p>📌 <strong>Base Foundation</strong>: Security-hardened, minimal base OS designed for enterprise containerized environments from Cleanstart Registry.</p>
<p><strong>Image Path</strong>: <code>Cleanstart/minio-operator-sidecar</code>
<p><strong>Key Features</strong>
Core capabilities and strengths of this container</p>
<ul>
<li>Automated MinIO cluster management and orchestration</li>
<li>Kubernetes-native deployment and scaling capabilities</li>
<li>Integrated monitoring and health checking</li>
<li>Automated certificate management and TLS configuration</li>
</ul>
<p><strong>Common Use Cases</strong>
Typical scenarios where this container excels</p>
<ul>
<li>Enterprise object storage deployment automation</li>
<li>Cloud-native storage infrastructure management</li>
<li>Multi-tenant storage orchestration</li>
<li>Scalable data backup and archive solutions</li>
</ul>
<p><strong>Pull Latest Image</strong>
Download the container image from the registry</p>
<pre><code class="lang-bash">docker pull cleanstart/minio-<span class="hljs-keyword">operator</span>-sideca
r:latest
</code></pre>
<pre><code class="lang-bash"> docker pull cleanstart/minio-<span class="hljs-keyword">operator</span>-sidecar:latest-dev
</code></pre>
<p><strong>Basic Run</strong>
Run the container with basic configuration</p>
<pre><code class="lang-bash">docker <span class="hljs-built_in">run</span> -<span class="hljs-keyword">it</span> <span class="hljs-comment">--name minio-operator-sidecar cleanstart/minio-operator-sidecar:latest</span>
</code></pre>
<p><strong>Production Deployment</strong>
Deploy with production security settings</p>
<pre><code class="lang-bash">docker run -d --name minio-operator-sidecar-prod \
  -<span class="ruby">-read-only \
</span>  -<span class="ruby">-security-opt=no-new-privileges \
</span>  -<span class="ruby">-user <span class="hljs-number">1000</span><span class="hljs-symbol">:</span><span class="hljs-number">1000</span> \
</span>  -<span class="ruby">e MINIO_OPERATOR_TLS_ENABLE=<span class="hljs-literal">true</span> \
</span>  -<span class="ruby">e MINIO_OPERATOR_CLUSTER_NAME=prod-cluster \
</span>  cleanstart/minio-operator-sidecar:latest
</code></pre>
<p><strong>Volume Mount</strong>
Mount local directory for persistent data</p>
<pre><code class="lang-bash">docker <span class="hljs-built_in">run</span> -v $(pwd)/<span class="hljs-built_in">config</span>:/opt/minio-<span class="hljs-keyword">operator</span>/<span class="hljs-built_in">config</span> \
  -v $(pwd)/certs:/opt/minio-<span class="hljs-keyword">operator</span>/certs \
  cleanstart/minio-<span class="hljs-keyword">operator</span>-sidecar:latest
</code></pre>
<p><strong>Environment Variables</strong>
Configuration options available through environment variables</p>
<table>
<thead>
<tr>
<th>Variable</th>
<th>Default</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>MINIO_OPERATOR_TLS_ENABLE</td>
<td>false</td>
<td>Enable TLS for operator communications</td>
</tr>
<tr>
<td>MINIO_OPERATOR_CLUSTER_NAME</td>
<td>minio-cluster</td>
<td>Name of the MinIO cluster</td>
</tr>
<tr>
<td>MINIO_OPERATOR_NAMESPACE</td>
<td>minio-operator</td>
<td>Kubernetes namespace for operator</td>
</tr>
<tr>
<td>MINIO_OPERATOR_IMAGE_PULL_SECRET</td>
<td>&#39;&#39;</td>
<td>Image pull secret for private registries</td>
</tr>
</tbody>
</table>
<p><strong>Security Best Practices</strong>
Recommended security configurations and practices</p>
<ul>
<li>Enable TLS for all communications</li>
<li>Implement proper RBAC policies</li>
<li>Use secure secrets management</li>
<li>Regular security patches and updates</li>
<li>Network policy implementation</li>
<li>Resource quota enforcement</li>
</ul>
<p><strong>Kubernetes Security Context</strong>
Recommended security context for Kubernetes deployments</p>
<pre><code class="lang-yaml"><span class="hljs-attr">securityContext:</span>
<span class="hljs-attr">  runAsNonRoot:</span> <span class="hljs-literal">true</span>
<span class="hljs-attr">  runAsUser:</span> <span class="hljs-number">1000</span>
<span class="hljs-attr">  runAsGroup:</span> <span class="hljs-number">1000</span>
<span class="hljs-attr">  fsGroup:</span> <span class="hljs-number">1000</span>
<span class="hljs-attr">  readOnlyRootFilesystem:</span> <span class="hljs-literal">true</span>
<span class="hljs-attr">  allowPrivilegeEscalation:</span> <span class="hljs-literal">false</span>
<span class="hljs-attr">  capabilities:</span>
<span class="hljs-attr">    drop:</span> [<span class="hljs-string">"ALL"</span>]
<span class="hljs-attr">  seccompProfile:</span>
<span class="hljs-attr">    type:</span> RuntimeDefault
</code></pre>
<p><strong>Documentation Resources</strong>
Essential links and resources for further information</p>
<ul>
<li><strong>MinIO Operator Documentation</strong>: <a href="https://docs.min.io/minio/k8s/">https://docs.min.io/minio/k8s/</a></li>
<li><strong>Container Registry</strong>: <a href="https://www.cleanstart.com/">https://www.cleanstart.com/</a></li>
<li><strong>MinIO GitHub Repository</strong>: <a href="https://github.com/minio/operator">https://github.com/minio/operator</a></li>
</ul>
