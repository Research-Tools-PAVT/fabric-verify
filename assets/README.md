1.  To come up with a specification language which can be used to
    specify the properties/ features we want to test / assert in
    in the smart contract. The verification tool can than validate
    against those points and possibly come up with some counter
    examples or cases where the specifications fail to encode a bug or
    vulnerability. Now whether it works on the smart contract
    code or on the platform i.e including the deployment specification
    is a decision we make later on.

2.  To come up with an adversarial model or encode a threat model which
    can be used to simulate the specific attacks that can
    be tested using the specification as described above.

## Phases :

First phase will be to make sure that smart contract level issues
that arise due to buggy implementation or wrongful setup / endorsement policy
etc are covered. Secured information flow properties, non-interference and
transaction integrity etc is covered.

The second phase will be to verify end-to-end fabric deployment and is
infrastructure related. These will be issues related to how fabric works
and how each component in the architecture is interacting i.e
peer-to-orderer communication, transaction ordering etc.
