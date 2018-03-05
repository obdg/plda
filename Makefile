CC=g++
MPICC=mpicxx

CFLAGS=-O3 -Wall -Wno-sign-compare
OBJ_PATH = ./obj

all: lda infer mpi_lda lm_plda

clean:
	rm -rf $(OBJ_PATH)
	rm -f lda mpi_lda infer db_test lm_plda

OBJ_SRCS := cmd_flags.cc common.cc document.cc model.cc accumulative_model.cc sampler.cc add_timestamp.cc
ALL_OBJ = $(patsubst %.cc, %.o, $(OBJ_SRCS))
OBJ = $(addprefix $(OBJ_PATH)/, $(ALL_OBJ))

$(OBJ_PATH)/%.o: %.cc
	@ mkdir -p $(OBJ_PATH) 
	$(CC) -c $(CFLAGS) $< -o $@

lda: lda.cc $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) $< -o $@

infer: infer.cc $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) $< -o $@

mpi_lda: mpi_lda.cc $(OBJ)
	$(MPICC) $(CFLAGS) $(OBJ) $< -o $@

db_test: db_test.cc $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) $< -o $@ -lpqxx -lpq

db_test_lda: db_test_lda.cc $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) $< -o $@ -lpqxx -lpq

daemon_test: daemon_test.cc $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) $< -o $@ -lpqxx -lpq

lm_plda: lm_plda.cc $(OBJ)
	$(MPICC) $(CFLAGS) -std=c++14 $(OBJ) $< -o $@ -lpqxx -lpq  -ltacopie -lcpp_redis -lpthread
