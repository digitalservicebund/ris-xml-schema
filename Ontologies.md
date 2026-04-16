# Ontologien

Dokumentation für Ontologie-Werte die in den Schemas verwendet werden.

Grundsätzlich:

- lowercase
- Umlaute werden ersetzt (`ä` -> `ae`, `ü` -> `ue`, `ö` -> `oe`, `ß` -> `ss`)
- Leerzeichen werden durch `-` ersetzt
- Sonderzeichen (außer `-`) werden entfernt

## Gericht

Grundsätzlich

```
/akn/ontology/organizations/de/ris/gericht/{typ}-{ort}
```

Bundesgerichte

```
/akn/ontology/organizations/de/ris/gericht/{typ}
```

### Beispiele

- VG Aachen: `/akn/ontology/organizations/de/ris/gericht/vg-aachen`
- AG Neustadt (Rübenberge): `/akn/ontology/organizations/de/ris/gericht/ag-neustadt-ruebenberge`
- BVerfG: `/akn/ontology/organizations/de/ris/gericht/bverfg`

## Dokumentation-Stellen

```
/akn/ontology/organizations/de/ris/dokumentationsstelle/{abkürzung}
```

### Beispiele

- BVerfG: `/akn/ontology/organizations/de/ris/dokumentationsstelle/bverwg`

## Rechtsinformationssystem des Bundes

```
/akn/ontology/organizations/de/ris/rechtsinformationssystem-des-bundes
```

Für `source`-Angaben wollen wir auf das Rechtsinformationssystem des Bundes selbst verweisen.

## Literatur Rollen

Rollen die Personen oder Organisationen im Kontext eines Literatur-Dokuments einnehmen können

### Verfasser

```
/akn/ontology/roles/de/ris/literatur/verfasser
```

### Herausgeber (Person)

```
/akn/ontology/roles/de/ris/literatur/herausgeber-person
```

### Bearbeiter

```
/akn/ontology/roles/de/ris/literatur/bearbeiter
```

### Hochschule

```
/akn/ontology/roles/de/ris/literatur/hochschule
```

### Verlag

```
/akn/ontology/roles/de/ris/literatur/verlag
```

## Personen

Unsere Daten erlauben es uns nicht Personen sicher eindeutig zu identifizieren. Daher nutzen wir hierfür keine
Ontologie-Werte. Stattdessen legen wir die Informationen, die wir haben im `ris:meta` Bereich in `ris:person` Elementen
ab.

## Weitere Organisationen

Unsere Daten erlauben es uns nicht Organisationen sicher eindeutig zu identifizieren. Daher nutzen wir hierfür keine
Ontologie-Werte. Stattdessen legen wir die Informationen, die wir haben im `ris:meta` Bereich in `ris:organisation`
Elementen ab.

## TODOs

- [ ] is `/akn/ontology/organizations/de/ris` really a good prefix?
- [ ] Wie gehen wir mit den 3 Vergabekammern um, für die die Gerichts Ontologie nicht eindeutig ist?
