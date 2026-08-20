# SoundIsle Compatibility Kill Switch

A release may locally disable an optional risky capability when compatibility evidence shows it is unsafe.

Rules:
- never delete or lock user durable data;
- core local/offline access must not depend on a remote switch;
- default behavior remains defined in shipped code;
- gate changes are observable/diagnosable;
- gates target capabilities, not individual users;
- a disabled optional feature degrades clearly instead of silently corrupting state.

Remote configuration, if ever introduced, requires a separate security/privacy design and is not assumed by this specification.
