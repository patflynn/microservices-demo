package hipster

deployment "redis-cart": {
	// Copyright 2018 Google LLC
	//
	// Licensed under the Apache License, Version 2.0 (the "License");
	// you may not use this file except in compliance with the License.
	// You may obtain a copy of the License at
	//
	//      http://www.apache.org/licenses/LICENSE-2.0
	//
	// Unless required by applicable law or agreed to in writing, software
	// distributed under the License is distributed on an "AS IS" BASIS,
	// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	// See the License for the specific language governing permissions and
	// limitations under the License.
	apiVersion: "extensions/v1beta1"
	kind:       "Deployment"
	metadata name: "redis-cart"
	spec template: {
		metadata labels app: "redis-cart"
		spec: {
			containers: [{
				name:  "redis"
				image: "redis:alpine"
				ports: [{
					containerPort: 6379
				}]
				readinessProbe: {
					periodSeconds: 5
					tcpSocket port: 6379
				}
				livenessProbe: {
					periodSeconds: 5
					tcpSocket port: 6379
				}
				volumeMounts: [{
					mountPath: "/data"
					name:      "redis-data"
				}]
				resources: {
					limits: {
						memory: "256Mi"
						cpu:    "125m"
					}
					requests: {
						cpu:    "70m"
						memory: "200Mi"
					}
				}
			}]
			volumes: [{
				name: "redis-data"
				emptyDir: {
				}
			}]
		}
	}
}
service "redis-cart": {
	apiVersion: "v1"
	kind:       "Service"
	metadata name: "redis-cart"
	spec: {
		type: "ClusterIP"
		selector app: "redis-cart"
		ports: [{
			name:       "redis"
			port:       6379
			targetPort: 6379
		}]
	}
}
