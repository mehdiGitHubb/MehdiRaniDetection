




% Conditions aux actions primitives



poss(assign(P, D,T), S):- doctor(D), not(assigned(P, D, S)).

poss(patientAdmission(P, T), S):-  assigned(P, D, S),not(inpatient(P, T1, S)).

poss(patientAdmission(P,T),S):- assigned(P,D,S),(doctor(D)).

poss(revokeAssignation(P, D, T), S):- assigned(P, D, S).

poss(leave(P, T), S):-inpatient(P, T1, S).





poss(startWrite(D, admissionNote, P, T, T1), S):-perm(startWrite(D, admissionNote, P, T, T1), S),
                                                 not(writingDoc(D, admissionNote, P, T, T2, S)),
                                                 not(writtenDoc(D, admissionNote, P, T, S)).

poss(startWrite(D, observation, P, T, T1), S):-  perm(startWrite(D, observation, P, T, T1), S),
                                                 not(writingDoc(D, observation, P, T, T2, S)),
                                                 not(writtenDoc(D, observation, P, T, S)).


poss(endWrite(D, Type, P, T, T1), S):- perm(endWrite(D, Type, P, T, T1), S).


poss(endDeadline(admissionNote, P, T, T1), S):- inpatient(P, T, S),
                                                not(deadline(admissionNote, P, T , S)),
                                                adDeadline(Deadline), T1 = T + Deadline.

poss(endDeadline(observation, P, T, T1), S):- inpatient(P, T, S),
                                              not(deadline(observation, P, T , S)),
                                               obDeadline(Deadline), T1 = T + Deadline.

% Axiomes de l'état successeur.



assigned(P, D, do(A, S)):-  A =  assign(P, D, T);
                            (assigned(P, D, S),
			    not(A = revokeAssignation(P, D, T1)),
                            not(A = leave(P, T2))).
                            

deadline(Type, P, T, do(A, S)):-  A = endDeadline(Type, P, T, T1);
                                  deadline(Type, P, T, S).

inpatient(P, T, do(A, S)):-  A = patientAdmission(P, T);
                             (inpatient(P, T, S),
                             not(A = leave(P, T1))).

writingDoc(D, Type, P, T, T1, do(A, S)):- A = startWrite(D, Type, P, T, T1);
                                          (writingDoc(D, Type, P, T, T1, S),
                                          not(A = endWrite(D, Type, P, T, T2))).

writtenDoc(D, Type, P, T, do(A, S)):- A = endWrite(D, Type, P, T, T1);
                                      writtenDoc(D, Type, P, T, S).

% permissions actives dérivées.


perm(startWrite(D, observation, P, T, T1), do(A, S)):- assigned(P, D, S),
                                                       not(writingDoc(D, Type1, P1 , T2 , T3, S)),
                                                       A = patientAdmission(P, T).

perm(startWrite(D, observation, P, T, T1), do(A, S)):- assigned(P, D, S), inpatient(P, T, S),
                                                       A = endWrite(D, Type1, P1, T2, T3).

perm(startWrite(D, observation, P, T, T1), do(A, S)):- perm(startWrite(D, observation, P, T, T1), S),
                                                         not(A = revokeAssignment(P, D, T2)),
                                                         not(A = leave(P, T2)),
                                                         not(A = startWrite(D, Type1 , P1, T3 , T4)).


perm(startWrite(D, admissionNote, P, T, T1), do(A, S)):- assigned(P, D, S),
                                                         not(writingDoc(D, Type1, P1 , T2 , T3, S)),
                                                         A = patientAdmission(P, T).

perm(startWrite(D, admissionNote, P, T, T1), do(A, S)):- assigned(P, D, S), inpatient(P, T, S),
                                                         A = endWrite(D, Type1, P1, T2, T3).

perm(startWrite(D, admissionNote, P, T, T1), do(A, S)):- perm(startWrite(D, admissionNote, P, T, T1), S),
                                                         not(A = revokeAssignment(P, D, T2)),
                                                         not(A = leave(P, T2)),
                                                         not(A = startWrite(D, Type1 , P1, T3 , T4)).


perm(endWrite(D, Type, P, T, T1), do(A, S)):- A = startWrite(D, Type, P, T, T2), T1 >= T2 + 5.

perm(endWrite(D, Type, P, T, T1), do(A, S)):- perm(endWrite(D, Type, P, T, T1), S),
                                              not(A = endWrite(D, Type, P, T, T2)).


% Obligations actives dérivées.

ob(write(D, admissionNote, P, T), do(A, S)):-  (assigned(P, D, S),
                                                A = patientAdmission(P, T));
                                               (ob(write(D, admissionNote, P, T), S),
                                                not(A = endWrite(D, admissionNote, P, T, T1)),
                                                not(A = endDeadline(admissionNote, P, T, T2)),
                                                not(A = leave(P, T3)),
                                                not(A = revokeAssignation(P, D, T4))).

ob(write(D, observation, P, T), do(A, S)):-  (assigned(P, D, S),
                                              A = patientAdmission(P, T));
                                             (ob(write(D, observation, P, T), S),
                                              not(A = endWrite(D, observation, P, T, T1)),
                                              not(A = endDeadline(observation, P, T, T2)),
                                              not(A = leave(P, T3)),
                                              not(A = revokeAssignation(P, D, T4))).

ob(endDeadline(admissionNote, P, T, T1), do(A, S)):- (A =  patientAdmission(P, T),
                                                      adDeadline(Deadline), T1 = T + Deadline);
                                                     (ob(endDeadline(admissionNote, P, T, T1), S),
                                                      not(A = endDeadline(admissionNote, P, T, T1)),
                                                      not(A = leave(P, T2))).

ob(endDeadline(observation, P, T, T1), do(A, S)):- (A = patientAdmission(P, T),
                                                    obDeadline(Deadline), T1 = T + Deadline);
                                                   (ob(endDeadline(observation, P, T, T1), S),
                                                    not(A = endDeadline(observation, P, T, T1)),
                                                    not(A = leave(P, T2))).




/* Initial Situation.*/


start(s0,0).
doctor(ali).
patien(p).

adDeadline(30).
obDeadline(40).



% le temps d'une occurrence d'action est son dernier argument.

time(assign(P, D, T), T).
time(revokeAssignation(P, D, T), T).
time(patientAdmission(P, T), T).
time(leave(P, T), T).
time(endDeadline(Type, P, T, T1), T1).
time(startWrite(D, Type, P, T, T1), T1).
time(endWrite(D, Type, P, T, T1), T1).






% Déclarations d'action primitives.



primitiveAction(startWrite(D, Type, P, T, T1)).
primitiveAction(endWrite(D, Type, P, T, T1)).
primitiveAction(endDeadline(Type, P, T, T1)).
primitiveAction(revokeAssignation(P, D, T)).
primitiveAction(assign(P, D, T)).
primitiveAction(patientAdmission(P, T)).
primitiveAction(leave(P, T)).



























