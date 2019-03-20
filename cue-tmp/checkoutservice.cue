package hipster

deployment checkoutservice: {
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
	metadata name: "checkoutservice"
	spec template: {
		metadata labels app: "checkoutservice"
		spec containers: [{
			name:  "server"
			image: "checkoutservice"
			ports: [{
				containerPort: 5050
			}]
			readinessProbe exec command: ["/bin/grpc_health_probe", "-addr=:5050"]
			livenessProbe exec command: ["/bin/grpc_health_probe", "-addr=:5050"]
			env: [{
				name:  "PRODUCT_CATALOG_SERVICE_ADDR"
				value: "productcatalogservice:3550"
			}, {
				name:  "SHIPPING_SERVICE_ADDR"
				value: "shippingservice:50051"
			}, {
				name:  "PAYMENT_SERVICE_ADDR"
				value: "paymentservice:50051"
			}, {
				name:  "EMAIL_SERVICE_ADDR"
				value: "emailservice:5000"
			}, {
				name:  "CURRENCY_SERVICE_ADDR"
				value: "currencyservice:7000"
			}, {
				name:  "CART_SERVICE_ADDR"
				value: "cartservice:7070"
			}]
			// - name: JAEGER_SERVICE_ADDR
			//   value: "jaeger-collector:14268"
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
service checkoutservice: {
	apiVersion: "v1"
	kind:       "Service"
	metadata name: "checkoutservice"
	spec: {
		type: "ClusterIP"
		selector app: "checkoutservice"
		ports: [{
			name:       "grpc"
			port:       5050
			targetPort: 5050
		}]
	}
}