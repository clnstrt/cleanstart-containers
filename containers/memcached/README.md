<p><strong>CleanStart Container for Memcached</strong></p>
<p>Enterprise-grade Memcached distributed memory caching system container optimized for high-performance caching scenarios. This container includes the latest stable Memcached server with security hardening and enterprise features. Memcached is an in-memory key-value store for small chunks of arbitrary data from results of database calls, API calls, or page rendering. The container is configured for optimal performance in distributed systems with support for multiple protocols and authentication mechanisms.</p>
<p>📌 <strong>CleanStart Foundation</strong>: Security-hardened, minimal base OS designed for enterprise containerized environments.</p>
<p><strong>Key Features</strong></p>
<ul>
<li>High-performance distributed memory caching</li>
<li>Multi-threaded architecture for concurrent connections</li>
<li>Support for multiple protocols (ASCII and binary)</li>
<li>Enterprise-grade security features and access controls</li>
</ul>
<p><strong>Common Use Cases</strong></p>
<ul>
<li>Database query result caching</li>
<li>Session storage for web applications</li>
<li>API response caching</li>
<li>Distributed caching layer in microservices architecture</li>
</ul>
<p><strong>Quick Start</strong></p>
<p><strong>Pull Latest Image</strong>
Download the container image from the registry</p>
<pre><code class="lang-bash">docker pull cleanstart/<span class="hljs-string">memcached:</span>latest
docker pull cleanstart/<span class="hljs-string">memcached:</span>latest-dev
</code></pre>
<p><strong>Basic Run</strong>
Run the container with basic configuration</p>
<pre><code class="lang-bash">docker <span class="hljs-keyword">run</span><span class="bash"> <span class="hljs-_">-d</span> --name memcached-instance -p 11211:11211 cleanstart/memcached:latest</span>
</code></pre>
<p><strong>Production Deployment</strong>
Deploy with production security settings</p>
<pre><code class="lang-bash">docker run -d --name memcached-prod \
  -<span class="ruby">-read-only \
</span>  -<span class="ruby">-security-opt=no-new-privileges \
</span>  -<span class="ruby">-user <span class="hljs-number">1000</span><span class="hljs-symbol">:</span><span class="hljs-number">1000</span> \
</span>  -<span class="ruby">p <span class="hljs-number">11211</span><span class="hljs-symbol">:</span><span class="hljs-number">11211</span> \
</span>  -<span class="ruby">m <span class="hljs-number">1024</span>m \
</span>  cleanstart/memcached:latest
</code></pre>
<p><strong>Volume Mount</strong>
Mount local directory for persistent data</p>
<pre><code class="lang-bash">docker <span class="hljs-keyword">run</span><span class="bash"> <span class="hljs-_">-d</span> -v $(<span class="hljs-built_in">pwd</span>)/memcached-data:/data cleanstart/memcached:latest</span>
</code></pre>
<p><strong>Port Forwarding</strong>
Run with custom port mappings</p>
<pre><code class="lang-bash">docker <span class="hljs-keyword">run</span><span class="bash"> <span class="hljs-_">-d</span> -p 11222:11211 cleanstart/memcached:latest</span>
</code></pre>
<p><strong>Configuration</strong></p>
<p><strong>Environment Variables</strong></p>
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
<td>PATH</td>
<td>/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin</td>
<td>System PATH configuration</td>
</tr>
<tr>
<td>MEMCACHED_MEMORY_LIMIT</td>
<td>64</td>
<td>Maximum memory to use for storage in megabytes</td>
</tr>
<tr>
<td>MEMCACHED_CONNECTIONS</td>
<td>1024</td>
<td>Maximum simultaneous connections</td>
</tr>
</tbody>
</table>
<p><strong>Security &amp; Best Practices</strong></p>
<p><strong>Recommended Security Context</strong></p>
<pre><code class="lang-yaml"><span class="hljs-attr">securityContext:</span>
<span class="hljs-attr">  runAsNonRoot:</span> <span class="hljs-literal">true</span>
<span class="hljs-attr">  runAsUser:</span> <span class="hljs-number">1000</span>
<span class="hljs-attr">  runAsGroup:</span> <span class="hljs-number">1000</span>
<span class="hljs-attr">  readOnlyRootFilesystem:</span> <span class="hljs-literal">true</span>
<span class="hljs-attr">  allowPrivilegeEscalation:</span> <span class="hljs-literal">false</span>
<span class="hljs-attr">  capabilities:</span>
<span class="hljs-attr">    drop:</span> [<span class="hljs-string">'ALL'</span>]
</code></pre>
<p><strong>Best Practices</strong></p>
<ul>
<li>Use specific image tags for production (avoid latest)</li>
<li>Configure resource limits: memory and CPU constraints</li>
<li>Enable read-only root filesystem when possible</li>
<li>Run containers with non-root user (--user 1000:1000)</li>
<li>Use --security-opt=no-new-privileges flag</li>
<li>Regularly update container images for security patches</li>
<li>Implement proper network segmentation</li>
<li>Monitor container metrics for anomalies</li>
</ul>
<p><strong>Architecture Support</strong></p>
<p><strong>Multi-Platform Images</strong></p>
<pre><code class="lang-bash">docker pull --platform linux<span class="hljs-regexp">/amd64 cleanstart/</span><span class="hljs-string">memcached:</span>latest
docker pull --platform linux<span class="hljs-regexp">/arm64 cleanstart/</span><span class="hljs-string">memcached:</span>latest
</code></pre>
<p><strong>Resources &amp; Documentation</strong></p>
<p><strong>Essential Links</strong></p>
<ul>
<li><strong>CleanStart Website</strong>: <a href="https://www.cleanstart.com">https://www.cleanstart.com</a></li>
<li><strong>Memcached Official Documentation</strong>: <a href="https://memcached.org/documentation">https://memcached.org/documentation</a></li>
</ul>
<hr>
