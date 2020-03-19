Class {
	#name : #MNMario,
	#superclass : #MNAbstractCharacter,
	#category : #MiniMario
}

{ #category : #'as yet unclassified' }
MNMario >> beat [
	super beat.
	"The game ends if Mario reaches the 
	 right-most position of the game"
	self position x = (game size x - 1) ifTrue: [ game gameOver ].

	"The game also ends if Mario bumps into a monster"	
	game monsters do: [ :m |
		(m position = self position) ifTrue: [ game gameOver ] ]
]
