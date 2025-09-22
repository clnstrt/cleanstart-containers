<p><strong>Container Documentation for Kyverno-Kyvernopre</strong></p>
<p>Kyverno Pre-validation webhook container that performs policy validation checks before Kubernetes admission requests. This container is essential for implementing policy-as-code, ensuring compliance, and maintaining security standards in Kubernetes clusters. It provides pre-admission policy enforcement, validation of resources against custom policies, and integration with existing security workflows.</p>
<p>📌 <strong>Base Foundation</strong>: Security-hardened, minimal base OS designed for enterprise containerized environments from cleanstart Registry.</p>
<p><strong>Image Path</strong>: <code>cleanstart/kyverno-kyvernopre</code>
<strong>Registry</strong>: cleanstart Registry</p>
<p><strong>Key Features</strong>
Core capabilities and strengths of this container</p>
<ul>
<li>Pre-admission policy validation for Kubernetes clusters</li>
<li>Custom policy enforcement and compliance checking</li>
<li>Integration with Kubernetes admission controllers</li>
<li>Support for complex validation rules and policies</li>
</ul>
<p><strong>Common Use Cases</strong>
Typical scenarios where this container excels</p>
<ul>
<li>Kubernetes cluster policy enforcement</li>
<li>Security compliance validation</li>
<li>Resource configuration validation</li>
<li>Automated policy checking in CI/CD pipelines</li>
</ul>
<p><strong>Pull Latest Image</strong>
Download the container image from the registry</p>
<pre><code class="lang-bash">docker pull cleanstart/kyverno-<span class="hljs-string">kyvernopre:</span>latest
</code></pre>
<pre><code class="lang-bash">docker pull cleanstart/kyverno-<span class="hljs-string">kyvernopre:</span>latest-dev
</code></pre>
<p><strong>Basic Run</strong>
Run the container with basic configuration</p>
<pre><code class="lang-bash">docker <span class="hljs-built_in">run</span> -<span class="hljs-keyword">it</span> <span class="hljs-comment">--name kyverno-pre cleanstart/kyverno-kyvernopre:latest</span>
</code></pre>
<p><strong>Production Deployment</strong>
Deploy with production security settings</p>
<pre><code class="lang-bash">docker run -d --name kyverno-pre-prod \
  -<span class="ruby">-read-only \
</span>  -<span class="ruby">-security-opt=no-new-privileges \
</span>  -<span class="ruby">-user <span class="hljs-number">1000</span><span class="hljs-symbol">:</span><span class="hljs-number">1000</span> \
</span>  cleanstart/kyverno-kyvernopre:latest
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
<td>KYVERNO_NAMESPACE</td>
<td>kyverno</td>
<td>Namespace where Kyverno is installed</td>
</tr>
<tr>
<td>KYVERNO_METRICS_PORT</td>
<td>9443</td>
<td>Port for metrics endpoint</td>
</tr>
<tr>
<td>LOG_LEVEL</td>
<td>INFO</td>
<td>Logging level (DEBUG, INFO, WARNING, ERROR)</td>
</tr>
<tr>
<td>WEBHOOK_TIMEOUT</td>
<td>10</td>
<td>Webhook timeout in seconds</td>
</tr>
</tbody>
</table>
<p><strong>Security Best Practices</strong>
Recommended security configurations and practices</p>
<ul>
<li>Use specific image tags for production deployments</li>
<li>Implement proper RBAC policies</li>
<li>Enable TLS for webhook communications</li>
<li>Regular security scanning of policies</li>
<li>Monitor policy validation metrics</li>
<li>Implement proper backup strategies for policies</li>
</ul>
<p><strong>Kubernetes Security Context</strong>
Recommended security context for Kubernetes deployments</p>
<pre><code class="lang-yaml"><span class="hljs-attr">securityContext:</span>
<span class="hljs-attr">  runAsNonRoot:</span> <span class="hljs-literal">true</span>
<span class="hljs-attr">  runAsUser:</span> <span class="hljs-number">1000</span>
<span class="hljs-attr">  runAsGroup:</span> <span class="hljs-number">1000</span>
<span class="hljs-attr">  readOnlyRootFilesystem:</span> <span class="hljs-literal">true</span>
<span class="hljs-attr">  allowPrivilegeEscalation:</span> <span class="hljs-literal">false</span>
<span class="hljs-attr">  capabilities:</span>
<span class="hljs-attr">    drop:</span> [<span class="hljs-string">"ALL"</span>]
</code></pre>
<p><strong>Documentation Resources</strong>
Essential links and resources for further information</p>
<ul>
<li><strong>Container Registry</strong>: <a href="https://www.cleanstart.com/">https://www.cleanstart.com/</a></li>
<li><strong>Kyverno Documentation</strong>: <a href="https://kyverno.io/docs/">https://kyverno.io/docs/</a></li>
</ul>
