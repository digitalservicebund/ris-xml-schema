# XML-schema for the Rechtsinformationssystem

This repo contains the XML-Schema files for the XML-files produced by the Rechtsinformationssystem.

## Getting started

| schema file                                                                          | namespace                                            | description                                                                        |
| ------------------------------------------------------------------------------------ | ---------------------------------------------------- | ---------------------------------------------------------------------------------- |
| [xsd/ris.xsd](./xsd/ris.xsd)                                                         | `http://rechtsinformationen.bund.de/schema/ris/0.1/` | Schema for all elements and types in the ris namespace                             |
| [xsd/caselaw-decision.xsd](./xsd/caselaw-decision.xsd)                               | `http://docs.oasis-open.org/legaldocml/ns/akn/3.0`   | Schema for caselaw decisions. (You should validate against this one)               |
| [xsd/caselaw-decision-meta.xsd](./xsd/caselaw-decision-meta.xsd)                     | `http://rechtsinformationen.bund.de/schema/ris/0.1/` | Restrictions for the ris namespace that only apply for caselaw decisions           |
| [xsd/caselaw-pending-proceeding.xsd](./xsd/caselaw-pending-proceeding.xsd)           | `http://docs.oasis-open.org/legaldocml/ns/akn/3.0`   | Schema for caselaw pending-proceeding. (You should validate against this one)      |
| [xsd/caselaw-pending-proceeding-meta.xsd](./xsd/caselaw-pending-proceeding-meta.xsd) | `http://rechtsinformationen.bund.de/schema/ris/0.1/` | Restrictions for the ris namespace that only apply for caselaw pending-proceedings |

## Usage

### Checking the schema against the examples

```bash
xmllint --noout --schema xsd/caselaw.xsd samples/caselaw/*.xml
```

### Git Hooks

For the provided Git hooks you will need to install [lefthook](https://github.com/evilmartians/lefthook/blob/master/docs/full_guide.md) (git hook manager), [Node.js](https://nodejs.org/en/download) (for installing the commit linter), and [talisman](https://thoughtworks.github.io/talisman/docs) (secrets scanner):

```bash
brew install lefthook talisman node
lefthook install
```

The following hooks are specified in the `lefthook.yml`:

- `commitlint` - write [conventional commit messages](https://chris.beams.io/posts/git-commit/)

Before pushing, the following checks are additionally ran:

- `secrets-audit` - avoid accidental pushes of [secrets and sensitive information](https://thoughtworks.github.io/talisman/)

## Code-Style

In general, we try to structure our xsd according to the ["Venetian Blind"-Design pattern](https://www.oracle.com/technical-resources/articles/java/design-patterns.html).
