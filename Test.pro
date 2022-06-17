test1:-poss(assign(_,D,_),s0), not(doctor(D)).

test2:-poss(assign(_,D,_),s0), doctor(D).

test3:-poss(assign(p, D,_),S), assigned(p, D, S).

test4:-poss(assign(p, D,_),s), doctor(D), not(assigned(p, D, s)).

test5:-poss(patientAdmission(p,_),s), not(assigned(p,_,s) ).

test6:-poss(patientAdmission(p,_),s), assigned(p,D,s) , not(doctor(D)).

test7:-poss(patientAdmission(p,T),s), inpatient(p,T1,s) , T1<T.

test8:-poss(revokeAssignation(p,D,_),do(assign(p, D, _), _)), assigned(p,D,do(assign(p, D, _), _)).

test9:-poss(revokeAssignation(p,D,_),s), not(assigned(p,D,s)).

test10:-poss(revokeAssignation(p,_,_),s0).

test11:-poss(revokeAssignation(p,D,_),do(assign(p,D1,_),s0)), not(D=D1).

test12:-poss(leave(_,_),s0).

test13:-poss(leave(p,10),s), inpatient(p,50,s).

test14:-poss(leave(p,T1),s),inpatient(p,T2,s),T2>T1.

test15:-poss(leave(p,10),do(patientAdmission(p, 2), _)), inpatient(p,2,do(patientAdmission(p, 2), _)).

test16:-poss(leave(p,t1),do(patientAdmission(p,t2),_)).

test17:-poss(leave(p,10),do(patientAdmission(p, 2), _)), inpatient(p,2,do(patientAdmission(p, 2), _)).

test18:-poss(startWrite(D,admissionNote,p,T,_),s), writtenDoc(D,admissionNote,p,T,s).

test19:-poss(startWrite(D,admissionNote,p,T,_),s), writingDoc(D,admissionNote, p,T,_,s).

test20:-poss(startWrite(D,admissionNote,p,_,_),s), not(assigned(p,D,s)).

test21:-poss(startWrite(D,admissionNote, p,_,_),do(revokeAssignation(p,D,_),s0)).

test22:-poss(startWrite(D,observation,p,T,_),s), writtenDoc(D, observation,p,T,s) .

test23:-poss(startWrite(D, observation,p,T,_),s), writingDoc(D, observation, p,T,_,s).

test24:-poss(startWrite(D, observation,p,_,_),s), not(assigned( p,D,s)).

test25:-poss(startWrite(D, observation,p,_,_),do(revokeAssignation(p,D,_),s0)).

test26:-poss(endWrite(D, type, P, _, _), s),not(perm(endWrite(D,type, P, _, _), s)).

test27:-poss(endDeadline(admissionNote,p1, _, _), s),not(inpatient(p1, _, s)).