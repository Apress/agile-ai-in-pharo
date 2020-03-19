Class {
	#name : #NENode,
	#superclass : #Object,
	#instVars : [
		'id',
		'kind',
		'connectionsCache',
		'innovationNumber',
		'numberOfInputs',
		'zValue',
		'numberOfReceivedValues',
		'result'
	],
	#category : #NEAT
}

{ #category : #'as yet unclassified' }
NENode >> connect: anotherNode weight: aWeight [
	"Establish a connection between two nodes (the receiver and the argument)
	 The method is executed by NEIndividual>>buildNetwork"
	connectionsCache add: aWeight -> anotherNode
]

{ #category : #'as yet unclassified' }
NENode >> connectedNodes [
	"Return the nodes that are connected to the node receiver"
	^ connectionsCache collect: #value as: Array
]

{ #category : #'as yet unclassified' }
NENode >> copy [
	"Return a copy of the node"
	| newNode |
	newNode := NENode new.
	newNode id: self id.
	newNode kind: self kind.
	newNode innovationNumber: self innovationNumber.
	^ newNode
]

{ #category : #'as yet unclassified' }
NENode >> evaluate: aValue [
	"Provide an input value to the node, and contribute to the intermediate zValue"

	"We just received a value. We add it to zValue."
	zValue := zValue + aValue.

	"We say we received a new value"
	numberOfReceivedValues := numberOfReceivedValues + 1.

	"If we received an adequate number of zValues, 
	 then we can compute the sigmoid, and keep it."
	numberOfReceivedValues = numberOfInputs ifFalse: [ ^ self ].
	result := self isInput ifTrue: [ zValue ] ifFalse: [ self sigmoid: zValue ].
	
	"We go here only if not output"
	connectionsCache do: [ :assoc | assoc value evaluate: result * assoc key ]
]

{ #category : #'as yet unclassified' }
NENode >> id [
	"Return the numerical identifier of the node"
	^ id
]

{ #category : #'as yet unclassified' }
NENode >> id: anInteger [
	"Set the node identifier, useful when an individual structure is modified"
	id := anInteger
]

{ #category : #'as yet unclassified' }
NENode >> increaseNumberOfInputs [
	"Increase the number of inputs values the node accept"
	numberOfInputs := numberOfInputs + 1
]

{ #category : #'as yet unclassified' }
NENode >> innovationNumber [
	"Return the innovation number, the historical marker, an integer"
	^ innovationNumber
]

{ #category : #'as yet unclassified' }
NENode >> innovationNumber: anInteger [
	"Set the node innovation number"
	innovationNumber := anInteger
]

{ #category : #'as yet unclassified' }
NENode >> isBias [
	"Return true if the node is the bias node,
	 i.e., if it has the id equals to 1"
	^ self isInput and: [ id = 1 ]
]

{ #category : #'as yet unclassified' }
NENode >> isInput [
	"Return true if the node is an input node"
	^ kind == #input
]

{ #category : #'as yet unclassified' }
NENode >> isOutput [
	"Return true if the node is an output node"
	^ kind == #output
]

{ #category : #'as yet unclassified' }
NENode >> kind [
	"Return the kind of node"
	^ kind
]

{ #category : #'as yet unclassified' }
NENode >> kind: aSymbol [
	"The argument aSymbol should either be #input, #output, or #hidden"
	kind := aSymbol
]

{ #category : #'as yet unclassified' }
NENode >> numberOfInputs [
	"Return the number of inputs the node accepts"
	^ numberOfInputs
]

{ #category : #'as yet unclassified' }
NENode >> printOn: stream [ 
	"Return a textual representation of a node. For example, a node may be printed
		a NENode<3,1,input>
	 or
	 	a NENode<5,205167,hidden>
	 The values 3 and 5 are the node id. 1 and 205167 are innovation number.
	 The third component indicates the kind of node
	 "
	super printOn: stream.
	stream nextPut: $<.
	id ifNotNil: [ stream nextPutAll: id asString ].
	stream nextPut: $,.
	innovationNumber ifNotNil: [ stream nextPutAll: innovationNumber asString ].
	stream nextPut: $,.
	kind ifNotNil: [ stream nextPutAll: kind asString ].
	stream nextPut: $>.
]

{ #category : #'as yet unclassified' }
NENode >> resetConnections [
	"Remove connections associated to a node"
	connectionsCache := OrderedCollection new.
	zValue := 0.
	numberOfInputs := 0.
	numberOfReceivedValues := 0.
	result := 0.
	self isInput ifTrue: [ numberOfInputs := 1 ]
]

{ #category : #'as yet unclassified' }
NENode >> result [
	"Return the computed result"
	^ result
]

{ #category : #'as yet unclassified' }
NENode >> setAsHidden [
	"Set the node as hidden, which means it is placed in the network between the input and output"
	kind := #hidden
]

{ #category : #'as yet unclassified' }
NENode >> setAsInput [
	"Set the node as input"
	kind := #input
]

{ #category : #'as yet unclassified' }
NENode >> setAsOutput [
	"Set the node as output"
	kind := #output
]

{ #category : #'as yet unclassified' }
NENode >> sigmoid: z [
	"Apply the sigmoid function to the argument"
	^ 1 / (1 + z negated exp)
]

{ #category : #'as yet unclassified' }
NENode >> weightOfConnectionWith: anotherNode [ 
	"Return the weight of the connection with another node"
	^ (connectionsCache detect: [ :assoc | assoc value == anotherNode ]) key
]
