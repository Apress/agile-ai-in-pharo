Class {
	#name : #NeuronLayerTest,
	#superclass : #TestCase,
	#category : #NeuralNetwork
}

{ #category : #'as yet unclassified' }
NeuronLayerTest >> testBasic [
	| nl result r |
	r := Random seed: 42.
	nl := NeuronLayer new.
	nl initializeNbOfNeurons: 3 nbOfWeights: 4 using: r.

	self assert: nl isOutputLayer.

	result := nl feed: #(1 2 3 4).
	self assert: result size equals: 3.
	result
		with: #(0.03700050130978758 0.9051275824569505 0.9815269659126287)
		do: [ :res :test | self assert: (res closeTo: test precision: 0.0000000001) ]
]

{ #category : #'as yet unclassified' }
NeuronLayerTest >> testOutputLayer [
	| nl1 nl2 result random |
	random := Random seed: 42.
	nl1 := NeuronLayer new.
	nl1 initializeNbOfNeurons: 3 nbOfWeights: 4 using: random.
	nl2 := NeuronLayer new.
	nl2 initializeNbOfNeurons: 4 nbOfWeights: 3 using: random.
	nl1 nextLayer: nl2.
	self deny: nl1 isOutputLayer.
	self assert: nl2 isOutputLayer.
	result := nl1 feed: #(1 2 3 4).
	"Since nl2 has 4 neurons, we will obtain 4 outputs"
	self assert: result size equals: 4.
	result
		with: #(0.03089402289518759 0.9220488835263312 0.5200462953493654 0.20276557516858304)
		do: [ :r :test | self assert: (r closeTo: test precision: 0.0000000001) ]
]
