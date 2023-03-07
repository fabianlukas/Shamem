condition = "encoding1";

exc_face   = [];
exc_space  = [];
exc_object = [];

for i=1:length(data_ana001)
exc_face   = [exc_face data_ana001(i).(condition).face.n_exclude];
exc_space  = [exc_space data_ana001(i).(condition).space.n_exclude];
exc_object = [exc_object data_ana001(i).(condition).object.n_exclude];
end
mean_face = mean(exc_face)
var_face  = var(exc_face)

mean_space = mean(exc_space)
var_space  = var(exc_space)

mean_object = mean(exc_object)
var_object  = var(exc_object)