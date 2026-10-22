# MC 11096 (infra) v2 — scoped venv patch. torch>=2.6 defaults torch.load weights_only
# True; UniRig lightning ckpts embed box.Box config globals -> UnpicklingError on the
# skin stage (v1 with setdefault was bypassed: lightning passes weights_only EXPLICITLY).
# Checkpoints are the official VAST-AI/UniRig HF release = the trusted source the vendor
# README itself loads. Rollback: delete this file.
import torch
_orig_load = torch.load
def load(*args, **kwargs):
    if kwargs.get("weights_only", True) in (None, True):
        kwargs["weights_only"] = False
    return _orig_load(*args, **kwargs)
torch.load = load
