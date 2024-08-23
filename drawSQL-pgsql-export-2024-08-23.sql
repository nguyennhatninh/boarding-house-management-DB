CREATE TABLE "Contracts"(
    "id" BIGINT NOT NULL,
    "user_id" BIGINT NOT NULL,
    "lessor_id" BIGINT NOT NULL,
    "room_id" BIGINT NOT NULL,
    "contract_term" VARCHAR(255) NOT NULL,
    "date_start" DATE NOT NULL,
    "date_end" DATE NOT NULL,
    "created_at" DATE NOT NULL,
    "updated_at" DATE NOT NULL
);
ALTER TABLE
    "Contracts" ADD PRIMARY KEY("id");
CREATE TABLE "Chats"(
    "id" BIGINT NOT NULL,
    "room_id" BIGINT NOT NULL,
    "user_id" BIGINT NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "content" VARCHAR(255) NOT NULL,
    "created_at" DATE NOT NULL,
    "updated_at" DATE NOT NULL
);
ALTER TABLE
    "Chats" ADD PRIMARY KEY("id");
CREATE TABLE "Lessors"(
    "id" BIGINT NOT NULL,
    "user_id" BIGINT NOT NULL,
    "verify_ownership" BOOLEAN NOT NULL
);
ALTER TABLE
    "Lessors" ADD PRIMARY KEY("id");
CREATE TABLE "Favorites"(
    "id" BIGINT NOT NULL,
    "room_id" BIGINT NOT NULL,
    "user_id" BIGINT NOT NULL
);
ALTER TABLE
    "Favorites" ADD PRIMARY KEY("id");
CREATE TABLE "Users"(
    "id" BIGINT NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "phone" INTEGER NOT NULL,
    "first_name" VARCHAR(255) NOT NULL,
    "last_name" VARCHAR(255) NOT NULL,
    "gender" VARCHAR(255) NOT NULL,
    "avarta" TEXT NOT NULL,
    "verify" BOOLEAN NOT NULL,
    "created_at" DATE NOT NULL,
    "updated_at" DATE NOT NULL
);
ALTER TABLE
    "Users" ADD PRIMARY KEY("id");
CREATE TABLE "Rooms"(
    "id" BIGINT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "price" BIGINT NOT NULL,
    "description" VARCHAR(255) NOT NULL,
    "image" TEXT NOT NULL,
    "capacity" INTEGER NOT NULL,
    "location" VARCHAR(255) NOT NULL,
    "lessor_id" BIGINT NOT NULL,
    "category" VARCHAR(255) NOT NULL,
    "status" VARCHAR(255) NOT NULL,
    "rate" FLOAT(53) NOT NULL,
    "created_at" DATE NOT NULL,
    "updated_at" DATE NOT NULL
);
ALTER TABLE
    "Rooms" ADD PRIMARY KEY("id");
CREATE TABLE "Comments"(
    "id" BIGINT NOT NULL,
    "contract_id" BIGINT NOT NULL,
    "content" VARCHAR(255) NOT NULL,
    "rate" INTEGER NOT NULL,
    "created_at" DATE NOT NULL,
    "updated_at" DATE NOT NULL
);
ALTER TABLE
    "Comments" ADD PRIMARY KEY("id");
CREATE TABLE "Payments"(
    "id" BIGINT NOT NULL,
    "contract_id" BIGINT NOT NULL,
    "status" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "Payments" ADD PRIMARY KEY("id");
CREATE TABLE "Messages"(
    "id" BIGINT NOT NULL,
    "chat_id" BIGINT NOT NULL,
    "user_id" BIGINT NOT NULL,
    "content" VARCHAR(255) NOT NULL,
    "time" DATE NOT NULL,
    "status" VARCHAR(255) NOT NULL,
    "created_at" DATE NOT NULL,
    "updated_at" DATE NOT NULL
);
ALTER TABLE
    "Messages" ADD PRIMARY KEY("id");
ALTER TABLE
    "Messages" ADD CONSTRAINT "messages_chat_id_foreign" FOREIGN KEY("chat_id") REFERENCES "Chats"("id");
ALTER TABLE
    "Lessors" ADD CONSTRAINT "lessors_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "Users"("id");
ALTER TABLE
    "Rooms" ADD CONSTRAINT "rooms_lessor_id_foreign" FOREIGN KEY("lessor_id") REFERENCES "Lessors"("id");
ALTER TABLE
    "Chats" ADD CONSTRAINT "chats_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "Users"("id");
ALTER TABLE
    "Messages" ADD CONSTRAINT "messages_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "Users"("id");
ALTER TABLE
    "Chats" ADD CONSTRAINT "chats_room_id_foreign" FOREIGN KEY("room_id") REFERENCES "Rooms"("id");
ALTER TABLE
    "Contracts" ADD CONSTRAINT "contracts_lessor_id_foreign" FOREIGN KEY("lessor_id") REFERENCES "Lessors"("id");
ALTER TABLE
    "Contracts" ADD CONSTRAINT "contracts_room_id_foreign" FOREIGN KEY("room_id") REFERENCES "Rooms"("id");
ALTER TABLE
    "Comments" ADD CONSTRAINT "comments_contract_id_foreign" FOREIGN KEY("contract_id") REFERENCES "Contracts"("id");
ALTER TABLE
    "Payments" ADD CONSTRAINT "payments_contract_id_foreign" FOREIGN KEY("contract_id") REFERENCES "Contracts"("id");
ALTER TABLE
    "Favorites" ADD CONSTRAINT "favorites_room_id_foreign" FOREIGN KEY("room_id") REFERENCES "Rooms"("id");
ALTER TABLE
    "Contracts" ADD CONSTRAINT "contracts_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "Users"("id");
ALTER TABLE
    "Favorites" ADD CONSTRAINT "favorites_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "Users"("id");