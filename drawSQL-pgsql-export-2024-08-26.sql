CREATE TABLE "contracts"(
    "id" bigserial NOT NULL,
    "renter_id" BIGINT NOT NULL,
    "lessor_id" BIGINT NOT NULL,
    "boarding_house_id" BIGINT NOT NULL,
    "contract_term" TEXT NOT NULL,
    "date_start" DATE NOT NULL,
    "date_end" DATE NOT NULL,
    "created_at" DATE NOT NULL DEFAULT CURRENT_DATE,
    "updated_at" DATE NOT NULL DEFAULT CURRENT_DATE
);
ALTER TABLE
    "contracts" ADD PRIMARY KEY("id");
CREATE TABLE "chats"(
    "id" bigserial NOT NULL,
    "boarding_house_id" BIGINT NOT NULL,
    "renter_id" BIGINT NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "content" VARCHAR(255) NOT NULL,
    "created_at" DATE NOT NULL DEFAULT CURRENT_DATE,
    "updated_at" DATE NOT NULL DEFAULT CURRENT_DATE
);
ALTER TABLE
    "chats" ADD PRIMARY KEY("id");
CREATE TABLE "lessors"(
    "id" bigserial NOT NULL,
    "user_id" BIGINT NOT NULL,
    "verify_ownership" BOOLEAN NOT NULL,
    "created_at" DATE NOT NULL DEFAULT CURRENT_DATE,
    "updated_at" DATE NOT NULL DEFAULT CURRENT_DATE
);
ALTER TABLE
    "lessors" ADD PRIMARY KEY("id");
CREATE TABLE "favorites"(
    "id" bigserial NOT NULL,
    "boarding_house_id" BIGINT NOT NULL,
    "renter_id" BIGINT NOT NULL,
    "created_at" DATE NOT NULL DEFAULT CURRENT_DATE,
    "updated_at" DATE NOT NULL DEFAULT CURRENT_DATE
);
ALTER TABLE
    "favorites" ADD PRIMARY KEY("id");
CREATE TABLE "users"(
    "id" bigserial NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "phone" VARCHAR(255) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "first_name" VARCHAR(255) NOT NULL,
    "last_name" VARCHAR(255) NOT NULL,
    "role" VARCHAR(255) CHECK
        ("role" IN('renter', 'lessor')) NOT NULL DEFAULT 'renter',
        "gender" VARCHAR(255)
    CHECK
        ("gender" IN('male', 'female')) NOT NULL,
        "avarta" TEXT NULL,
        "verify" BOOLEAN NULL,
        "address" VARCHAR(255) NULL,
        "created_at" DATE NOT NULL DEFAULT CURRENT_DATE,
        "updated_at" DATE NOT NULL DEFAULT CURRENT_DATE
);
ALTER TABLE
    "users" ADD PRIMARY KEY("id");
CREATE TABLE "boarding_houses"(
    "id" bigserial NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "price" BIGINT NOT NULL,
    "description" TEXT NOT NULL,
    "image" TEXT NULL,
    "capacity" VARCHAR(255) CHECK
        ("capacity" IN('2', '3', '4', '5')) NULL,
        "address" VARCHAR(255) NULL,
        "lessor_id" BIGINT NOT NULL,
        "category" VARCHAR(255)
    CHECK
        ("category" IN('popular', 'luxury')) NULL,
        "status" VARCHAR(255)
    CHECK
        ("status" IN('rented', 'available')) NULL,
        "rate" FLOAT(53) NULL,
        "created_at" DATE NOT NULL DEFAULT CURRENT_DATE,
        "updated_at" DATE NOT NULL DEFAULT CURRENT_DATE
);
ALTER TABLE
    "boarding_houses" ADD PRIMARY KEY("id");
CREATE TABLE "renters"(
    "id" bigserial NOT NULL,
    "user_id" BIGINT NOT NULL,
    "created_at" DATE NOT NULL DEFAULT CURRENT_DATE,
    "updated_at" DATE NOT NULL DEFAULT CURRENT_DATE
);
ALTER TABLE
    "renters" ADD PRIMARY KEY("id");
CREATE TABLE "comments"(
    "id" bigserial NOT NULL,
    "contract_id" BIGINT NOT NULL,
    "content" VARCHAR(255) NOT NULL,
    "rate" INTEGER NOT NULL,
    "created_at" DATE NOT NULL DEFAULT CURRENT_DATE,
    "updated_at" DATE NOT NULL DEFAULT CURRENT_DATE
);
ALTER TABLE
    "comments" ADD PRIMARY KEY("id");
CREATE TABLE "payments"(
    "id" bigserial NOT NULL,
    "contract_id" BIGINT NOT NULL,
    "status" VARCHAR(255) CHECK
        ("status" IN('pending', 'paid')) NOT NULL,
        "created_at" DATE NOT NULL DEFAULT CURRENT_DATE,
        "updated_at" DATE NOT NULL DEFAULT CURRENT_DATE
);
ALTER TABLE
    "payments" ADD PRIMARY KEY("id");
CREATE TABLE "messages"(
    "id" bigserial NOT NULL,
    "chat_id" BIGINT NOT NULL,
    "user_id" BIGINT NOT NULL,
    "content" VARCHAR(255) NOT NULL,
    "time" DATE NOT NULL,
    "status" VARCHAR(255) CHECK
        ("status" IN('seen', 'received')) NOT NULL,
        "created_at" DATE NOT NULL DEFAULT CURRENT_DATE,
        "updated_at" DATE NOT NULL DEFAULT CURRENT_DATE
);
ALTER TABLE
    "messages" ADD PRIMARY KEY("id");
ALTER TABLE
    "messages" ADD CONSTRAINT "messages_chat_id_foreign" FOREIGN KEY("chat_id") REFERENCES "chats"("id");
ALTER TABLE
    "favorites" ADD CONSTRAINT "favorites_renter_id_foreign" FOREIGN KEY("renter_id") REFERENCES "renters"("id");
ALTER TABLE
    "renters" ADD CONSTRAINT "renters_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "users"("id");
ALTER TABLE
    "lessors" ADD CONSTRAINT "lessors_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "users"("id");
ALTER TABLE
    "boarding_houses" ADD CONSTRAINT "boarding_houses_lessor_id_foreign" FOREIGN KEY("lessor_id") REFERENCES "lessors"("id");
ALTER TABLE
    "messages" ADD CONSTRAINT "messages_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "users"("id");
ALTER TABLE
    "chats" ADD CONSTRAINT "chats_boarding_house_id_foreign" FOREIGN KEY("boarding_house_id") REFERENCES "boarding_houses"("id");
ALTER TABLE
    "contracts" ADD CONSTRAINT "contracts_lessor_id_foreign" FOREIGN KEY("lessor_id") REFERENCES "lessors"("id");
ALTER TABLE
    "contracts" ADD CONSTRAINT "contracts_boarding_house_id_foreign" FOREIGN KEY("boarding_house_id") REFERENCES "boarding_houses"("id");
ALTER TABLE
    "comments" ADD CONSTRAINT "comments_contract_id_foreign" FOREIGN KEY("contract_id") REFERENCES "contracts"("id");
ALTER TABLE
    "payments" ADD CONSTRAINT "payments_contract_id_foreign" FOREIGN KEY("contract_id") REFERENCES "contracts"("id");
ALTER TABLE
    "favorites" ADD CONSTRAINT "favorites_boarding_house_id_foreign" FOREIGN KEY("boarding_house_id") REFERENCES "boarding_houses"("id");
ALTER TABLE
    "contracts" ADD CONSTRAINT "contracts_renter_id_foreign" FOREIGN KEY("renter_id") REFERENCES "renters"("id");
ALTER TABLE
    "chats" ADD CONSTRAINT "chats_renter_id_foreign" FOREIGN KEY("renter_id") REFERENCES "renters"("id");