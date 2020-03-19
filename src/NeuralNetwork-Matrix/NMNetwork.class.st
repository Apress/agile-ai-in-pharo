Class {
	#name : #NMNetwork,
	#superclass : #Object,
	#instVars : [
		'random',
		'errors',
		'layers'
	],
	#category : #'NeuralNetwork-Matrix'
}

{ #category : #'as yet unclassified' }
NMNetwork >> addLayer: aLayer [
	"Add a layer to the network. Note that layers form a bidirectional chain."
	layers ifNotEmpty: [
		layers last next: aLayer. 
		aLayer previous: layers last ].
	layers add: aLayer
]

{ #category : #'as yet unclassified' }
NMNetwork >> backwardX: x y: y [
	"Compute and backpropagate the error"
	| lastLayer dz currentLayer |
	lastLayer := layers last.
	dz := lastLayer output - y.	
	lastLayer delta: dz.
	currentLayer := lastLayer previous. 
	[ currentLayer notNil ] whileTrue: [ 
		dz := (currentLayer next w transposed +* dz) 
					multiplyPerElement: (currentLayer output collect: [ :v | v * (1 - v) ]).
		currentLayer delta: dz.
		currentLayer := currentLayer previous.
	].
]

{ #category : #'as yet unclassified' }
NMNetwork >> computeCost: v1 and: v2 [
	"Compute the cost function for two provided vectors"
	^ ((v1 - v2) collect: [ :v | v * v ]) sum
]

{ #category : #'as yet unclassified' }
NMNetwork >> configure: nbOfInputs hidden: nbOfNeurons1 hidden: nbOfNeurons2 nbOfOutputs: nbOfOutputs [
    "Configure the network with the given parameters. The network has two hidden layers"
	self addLayer: (NMLayer new nbInputs: nbOfInputs nbOutputs: nbOfNeurons1 random: random).
	self addLayer: (NMLayer new nbInputs: nbOfNeurons1 nbOutputs: nbOfNeurons2 random: random).
	self addLayer: (NMLayer new nbInputs: nbOfNeurons2 nbOutputs: nbOfOutputs random: random).
]

{ #category : #'as yet unclassified' }
NMNetwork >> configure: nbOfInputs hidden: nbOfNeurons nbOfOutputs: nbOfOutputs [
    "Configure the network with the given parameters
    The network has only one hidden layer"
	self addLayer: (NMLayer new nbInputs: nbOfInputs nbOutputs: nbOfNeurons random: random).
	self addLayer: (NMLayer new nbInputs: nbOfNeurons nbOutputs: nbOfOutputs random: random).
]

{ #category : #'as yet unclassified' }
NMNetwork >> feed: inputs [
	"Feed the network with the provided inputs vector
	Return the output value as a matrix"
	| mat |
	mat := inputs.
	layers do: [ :l | mat := l feed: mat ].
	^ mat
]

{ #category : #'as yet unclassified' }
NMNetwork >> initialize [
	"Initialize the network with no layer and a proper random generator"
	super initialize.
	layers := OrderedCollection new.
	random := Random seed: 42.
]

{ #category : #'as yet unclassified' }
NMNetwork >> lr: aLearningRateAsFloat [
	"Globally set the learning rate"
	layers do: [ :l | l lr: aLearningRateAsFloat ]
]

{ #category : #'as yet unclassified' }
NMNetwork >> predict: inputs [
	"Make a prediction. This method assume that the number of outputs is the same than the number of different values the network can output"
	"The index of a collection begins at 1 in Pharo,
	which is why we need to substrate 1"
	| outputs |
	outputs := self feed: inputs.
	^ (outputs asArray indexOf: (outputs max)) - 1
]

{ #category : #'as yet unclassified' }
NMNetwork >> train: data nbEpochs: nbEpochs [
	"Data is provided as a collection of arrays.
	The example data need to be labeled using a numerical value"
	| x y labels numberOfOutputs |
	x := (MMatrix newFromArrays: (data collect: #allButLast)) transposed.
	layers do: [ :l | l numberOfExamples: data size ].
	labels := data collect: #last.
	numberOfOutputs := labels asSet size.
	labels := labels collect: [ :row |
		| expectedOutput |
		expectedOutput := Array new: numberOfOutputs withAll: 0.
   		expectedOutput at: row + 1 put: 1.
		expectedOutput
	].
	y := (MMatrix newFromArrays: labels) transposed.
	^ self trainX: x y: y nbOfEpochs: nbEpochs
]

{ #category : #'as yet unclassified' }
NMNetwork >> trainX: x y: y nbOfEpochs: nbEpochs [
	"Train the network with a set of inputs against the expected values"
	| cost output |
	"We need to tell to each layer the number of examples they have"
	layers do: [ :l | l numberOfExamples: y nbColumns ].
	errors := OrderedCollection new.
	nbEpochs timesRepeat: [ 
		output := self feed: x.
		cost := self computeCost: output and: y.
		self backwardX: x  y: y.
		self update: x.
		errors add: cost.
	].
	^ cost
]

{ #category : #'as yet unclassified' }
NMNetwork >> update: input [
	"Update the weights and bias using the provided input vector"
	layers first update: input
]

{ #category : #'as yet unclassified' }
NMNetwork >> viewLearningCurve [
	| b ds |
	errors
		ifEmpty: [ ^ RTView new
				add: (RTLabel elementOn: 'Should first run the network');
				yourself ].
	b := RTGrapher new.
	"We define the size of the charting area"
	b extent: 500 @ 300.
	ds := RTData new.
	ds samplingIfMoreThan: 2000.
	ds noDot.
	ds connectColor: Color blue.
	ds points: (errors collectWithIndex: [ :y :i | i -> y ]).
	ds x: #key.
	ds y: #value.
	ds dotShape rectangle color: Color blue.
	b add: ds.
	b axisX noDecimal; title: 'Epoch'.
	b axisY title: 'Error'.
	^ b
]

{ #category : #'as yet unclassified' }
NMNetwork >> viewLearningCurveIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal2
		title: 'Cost';
		initializeView: [ self viewLearningCurve ]
]
