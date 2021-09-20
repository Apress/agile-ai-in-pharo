Class {
	#name : #Neuron,
	#superclass : #Object,
	#instVars : [
		'weights',
		'bias',
		'learningRate',
		'activationFunction',
		'delta',
		'output'
	],
	#category : #NeuralNetwork
}

{ #category : #'as yet unclassified' }
Neuron >> adjustBias [
	bias := bias + (learningRate * delta)
]

{ #category : #'as yet unclassified' }
Neuron >> adjustDeltaWith: anError [
	delta := anError * (activationFunction derivative: output)
]

{ #category : #'as yet unclassified' }
Neuron >> adjustWeightWithInput: inputs [
	inputs withIndexDo: [ :anInput :index | 
		weights at: index put: ((weights at: index) + (learningRate * delta * anInput)) ]
]

{ #category : #'as yet unclassified' }
Neuron >> bias [
	"Return the bias of the neuron"
	^ bias
]

{ #category : #'as yet unclassified' }
Neuron >> bias: aNumber [
	"Set the bias of the neuron"
	bias := aNumber
]

{ #category : #'as yet unclassified' }
Neuron >> delta [
	"Return the delta value computed when propagating the error"
	^ delta
]

{ #category : #'as yet unclassified' }
Neuron >> feed: inputs [
	| z |
	z := (inputs with: weights collect: [ :x :w | x * w ]) sum + bias.
	output := activationFunction eval: z.
	^ output    
]

{ #category : #'as yet unclassified' }
Neuron >> initialize [
	super initialize.
	learningRate := 0.1.
	self sigmoid
]

{ #category : #'as yet unclassified' }
Neuron >> learningRate [
	"Return the learning rate of the neuron"
	^ learningRate 
]

{ #category : #'as yet unclassified' }
Neuron >> learningRate: aLearningRateAsFloat [
	"Set the learning rate of the neuron. The argument should be a small floating value. For example, 0.01"
	learningRate := aLearningRateAsFloat
]

{ #category : #'as yet unclassified' }
Neuron >> numberOfWeights [
	"Return the number of weights contained in the neuron"
	^ weights size
]

{ #category : #'as yet unclassified' }
Neuron >> output [
	"Return the output value, previous computed when doing a feed:"
	^ output
]

{ #category : #'as yet unclassified' }
Neuron >> sigmoid [
	"Use the sigmoid activation function"
	activationFunction := SigmoidAF new
]

{ #category : #'as yet unclassified' }
Neuron >> step [
	"Use the step activation function"
	activationFunction := StepAF new
]

{ #category : #'as yet unclassified' }
Neuron >> train: inputs desiredOutput: desiredOutput [
    | diff output delta |
    output := self feed: inputs.
    diff := desiredOutput - output.
    delta := diff * (activationFunction derivative: output).    

    inputs withIndexDo: [ :anInput :index | 
        weights at: index put: ((weights at: index) + (learningRate * delta * anInput)) ].

    bias := bias + (learningRate * delta)
]

{ #category : #'as yet unclassified' }
Neuron >> weights [
	"Return the weights of the neuron."
	^ weights
]

{ #category : #'as yet unclassified' }
Neuron >> weights: someWeightsAsNumbers [
	"Set the weights of the neuron. 
	 Takes a collection of numbers as argument."
	weights := someWeightsAsNumbers asOrderedCollection
]
