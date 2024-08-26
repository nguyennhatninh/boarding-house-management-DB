CREATE TABLE "contracts"(
    "id" BIGINT NOT NULL,
    "renter_id" BIGINT NOT NULL,
    "lessor_id" BIGINT NOT NULL,
    "boarding_house_id" BIGINT NOT NULL,
    "contract_term" TEXT NOT NULL,
    "date_start" DATE NOT NULL,
    "date_end" DATE NOT NULL,
    "created_at" DATE NOT NULL,
    "updated_at" DATE NOT NULL
);
ALTER TABLE
    "contracts" ADD PRIMARY KEY("id");
CREATE TABLE "chats"(
    "id" BIGINT NOT NULL,
    "boarding_house_id" BIGINT NOT NULL,
    "renter_id" BIGINT NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "content" VARCHAR(255) NOT NULL,
    "created_at" DATE NOT NULL,
    "updated_at" DATE NOT NULL
);
ALTER TABLE
    "chats" ADD PRIMARY KEY("id");
CREATE TABLE "lessors"(
    "id" BIGINT NOT NULL,
    "user_id" BIGINT NOT NULL,
    "verify_ownership" BOOLEAN NOT NULL,
    "created_at" DATE NOT NULL,
    "updated_at" DATE NOT NULL
);
ALTER TABLE
    "lessors" ADD PRIMARY KEY("id");
CREATE TABLE "favorites"(
    "id" BIGINT NOT NULL,
    "boarding_house_id" BIGINT NOT NULL,
    "renter_id" BIGINT NOT NULL,
    "created_at" DATE NOT NULL,
    "updated_at" DATE NOT NULL
);
ALTER TABLE
    "favorites" ADD PRIMARY KEY("id");
CREATE TABLE "users"(
    "id" BIGINT NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "phone" INTEGER NOT NULL,
    "first_name" VARCHAR(255) NOT NULL,
    "last_name" VARCHAR(255) NOT NULL,
    "gender" VARCHAR(255) CHECK
        ("gender" IN('')) NOT NULL,
        "avarta" TEXT NOT NULL,
        "verify" BOOLEAN NOT NULL,
        "created_at" DATE NOT NULL,
        "updated_at" DATE NOT NULL
);
ALTER TABLE
    "users" ADD PRIMARY KEY("id");
CREATE TABLE "boarding_houses"(
    "id" BIGINT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "price" BIGINT NOT NULL,
    "description" TEXT NOT NULL,
    "image" TEXT NOT NULL,
    "capacity" VARCHAR(255) CHECK
        ("capacity" IN('')) NOT NULL,
        "location" VARCHAR(255) NOT NULL,
        "lessor_id" BIGINT NOT NULL,
        "category" VARCHAR(255)
    CHECK
        ("category" IN('')) NOT NULL,
        "status" VARCHAR(255)
    CHECK
        ("status" IN('')) NOT NULL,
        "rate" FLOAT(53) NOT NULL,
        "created_at" DATE NOT NULL,
        "updated_at" DATE NOT NULL
);
ALTER TABLE
    "boarding_houses" ADD PRIMARY KEY("id");
CREATE TABLE "renters"(
    "id" BIGINT NOT NULL,
    "user_id" BIGINT NOT NULL
);
ALTER TABLE
    "renters" ADD PRIMARY KEY("id");
CREATE TABLE "comments"(
    "id" BIGINT NOT NULL,
    "contract_id" BIGINT NOT NULL,
    "content" VARCHAR(255) NOT NULL,
    "rate" INTEGER NOT NULL,
    "created_at" DATE NOT NULL,
    "updated_at" DATE NOT NULL
);
ALTER TABLE
    "comments" ADD PRIMARY KEY("id");
CREATE TABLE "payments"(
    "id" BIGINT NOT NULL,
    "contract_id" BIGINT NOT NULL,
    "status" VARCHAR(255) CHECK
        ("status" IN('')) NOT NULL,
        "created_at" DATE NOT NULL,
        "updated_at" DATE NOT NULL
);
ALTER TABLE
    "payments" ADD PRIMARY KEY("id");
CREATE TABLE "messages"(
    "id" BIGINT NOT NULL,
    "chat_id" BIGINT NOT NULL,
    "user_id" BIGINT NOT NULL,
    "content" VARCHAR(255) NOT NULL,
    "time" DATE NOT NULL,
    "status" VARCHAR(255) CHECK
        ("status" IN('')) NOT NULL,
        "created_at" DATE NOT NULL,
        "updated_at" DATE NOT NULL
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