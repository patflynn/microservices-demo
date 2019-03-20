package hipster

deployment shippingservice: {
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
	metadata name: "shippingservice"
	spec template: {
		metadata labels app: "shippingservice"
		spec containers: [{
			name:  "server"
			image: "shippingservice"
			ports: [{
				containerPort: 50051
			}]
			readinessProbe: {
				periodSeconds: 5
				exec command: ["/bin/grpc_health_probe", "-addr=:50051"]
			}
			livenessProbe exec command: ["/bin/grpc_health_probe", "-addr=:50051"]
			//        env:
			//          - name: JAEGER_SERVICE_ADDR
			//            value: "jaeger-collector:14268"
			resources: {
				requests: {
					cpu:    "100m"
					memory: "64Mi"
				}
				limits: {
					cpu:    "200m"
					memory: "128Mi"
				}
			}
		}]
	}
}
service shippingservice: {
	apiVersion: "v1"
	kind:       "Service"
	metadata name: "shippingservice"
	spec: {
		type: "ClusterIP"
		selector app: "shippingservice"
		ports: [{
			name:       "grpc"
			port:       50051
			targetPort: 50051
		}]
	}
}
