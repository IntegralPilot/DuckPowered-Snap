duckpowered:
	snapcraft --destructive-mode
	snap install duckpowered*.snap --dangerous

clean:
	rm duckpowered*.snap
