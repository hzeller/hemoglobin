Plot der Daten zusammengestellt von
Scott Prahl <https://omlc.org/spectra/hemoglobin/> mit highlight von relevanten
Informationen die von Pulsoximetern gnutzt werden.

Rebuild: `make`

![](img/hem.png)

Wenn man mit einer Wellenlaenge misst, kann man noch nicht auf die Konzentration
schliessen, weil ja das Lumen unterschiedlich ist von Person zu Person (z.B.
Kinderfinger und Erwachsener mit Wurstfingern ... beim letzteren kommt weniger
Licht durch). Oder allein schon vom Puls, weil ja der Finger 'pumpt'.

Wenn man also nur bei einer Wellenlaenge schaut, dann sieht man mehr oder
weniger Licht, aber weil man kein Vergleichswert hat, kann man daraus noch
nicht auf die Konzentration schliessen.

Schaut man sich an, was zwei Sensoren bei 660nm und 940nm messen, dann sieht
man, dass bei O₂-gesattigtem Blut 3.8x mehr licht im Infraroten absorbiert wird
wie bei 660nm Rot.
Und bei ungesaettigtem Blut nur 0.21x soviel (oder
4.6x 'weniger'). Und das ist ja unabhaengig vom Finger: wenn einer mit doppelt
so dickem Finger gemessen wird, dann misst man in beiden Wellelängen nur
die Hälfte; aber da ja die Messung bei beiden Wellenlängen auf die Hälfte
reduziert sind, ist ja das erwartete Verhältnis von 3.8x immer noch gleich.

![](img/saturated-hem.png)

![](img/unsaturated-hem.png)

Also dadurch dass man bei beiden Wellenlaengen misst, rechnet sich das raus.

Das gleiche, wenn sich das Lumen aendert ('pumpen' im Finger): mal ist mehr,
mal weniger Blut in demselben Finger, aber bei voller Sättigung wird man immer
messen, dass im Infraroten 3.8x mehr absorbiert wird.

![](img/pulse.png)

Also duch das Messen an zwei Wellenlaengen rechnen sich Schwankungen
automatisch raus.
